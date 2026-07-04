import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/firebase_service.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final FirebaseService _firebaseService = FirebaseService();

  ChatRepositoryImpl({required this.remoteDataSource});

  String get _userId => _firebaseService.auth.currentUser?.uid ?? '';
  String get _userName => _firebaseService.auth.currentUser?.displayName ?? '';

  @override
  Future<ChatEntity> createChat(String adId, String sellerId) async {
    try {
      final existing = await remoteDataSource.getExistingChat(
        _userId,
        sellerId,
        adId,
      );
      if (existing != null) {
        final model = ChatModel.fromJson(
          existing.data() as Map<String, dynamic>,
          existing.id,
        );
        return ChatEntity.fromModel(model);
      }

      final chatModel = ChatModel(
        id: _firebaseService.firestore
            .collection('chats')
            .doc()
            .id,
        adId: adId,
        buyerId: _userId,
        sellerId: sellerId,
        buyerName: _userName,
      );

      final result = await remoteDataSource.createChat(chatModel);
      return ChatEntity.fromModel(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatEntity>> getChats() async {
    try {
      final models = await remoteDataSource.getChats(_userId);
      return models.map((model) => ChatEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MessageEntity>> getMessages(String chatId,
      {DocumentSnapshot? lastDoc}) async {
    try {
      var query = _firebaseService.firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt')
          .limit(50);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) =>
              MessageEntity.fromModel(MessageModel.fromJson(doc.data(), doc.id)))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MessageEntity> sendMessage(String chatId, String text,
      {File? image}) async {
    try {
      String? imageUrl;
      if (image != null) {
        imageUrl = await remoteDataSource.uploadChatImage(image, chatId);
      }

      final message = MessageModel(
        id: _firebaseService.firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc()
            .id,
        chatId: chatId,
        senderId: _userId,
        senderName: _userName,
        text: text,
        type: image != null ? 'image' : 'text',
        imageUrl: imageUrl,
      );

      final result = await remoteDataSource.sendMessage(message);
      return MessageEntity.fromModel(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(String chatId) async {
    try {
      await remoteDataSource.markAsRead(chatId, _userId);
    } catch (e) {
      rethrow;
    }
  }
}
