import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/config/firebase_config.dart';
import '../../../../core/services/firebase_service.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/message_model.dart';

class ChatRemoteDataSource {
  final FirebaseService _firebaseService = FirebaseService();

  Future<ChatModel> createChat(ChatModel chat) async {
    try {
      final docRef = _firebaseService.firestore
          .collection(FirebaseConfig.chatsCollection)
          .doc(chat.id);

      await docRef.set(chat.toJson());
      return chat;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create chat: ${e.message}');
    }
  }

  Future<MessageModel> sendMessage(MessageModel message) async {
    try {
      final docRef = _firebaseService.firestore
          .collection(FirebaseConfig.chatsCollection)
          .doc(message.chatId)
          .collection(FirebaseConfig.messagesCollection)
          .doc(message.id);

      await docRef.set(message.toJson());

      final chatDoc = await _firebaseService.firestore
          .collection(FirebaseConfig.chatsCollection)
          .doc(message.chatId)
          .get();

      if (chatDoc.exists) {
        final chat = ChatModel.fromJson(chatDoc.data()!, chatDoc.id);
        final isBuyer = message.senderId == chat.buyerId;

        await _firebaseService.firestore
            .collection(FirebaseConfig.chatsCollection)
            .doc(message.chatId)
            .update({
          'lastMessage': message.text.isNotEmpty ? message.text : '🖼️ صورة',
          'lastMessageType': message.type,
          'lastMessageTime': Timestamp.fromDate(message.createdAt),
          'lastSenderId': message.senderId,
          if (isBuyer) 'isReadBySeller': false,
          if (!isBuyer) 'isReadByBuyer': false,
          'updatedAt': Timestamp.fromDate(message.createdAt),
        });
      }

      return message;
    } on FirebaseException catch (e) {
      throw Exception('Failed to send message: ${e.message}');
    }
  }

  Future<List<ChatModel>> getChats(String userId) async {
    try {
      final buyerSnapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.chatsCollection)
          .where('buyerId', isEqualTo: userId)
          .orderBy('lastMessageTime', descending: true)
          .get();

      final sellerSnapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.chatsCollection)
          .where('sellerId', isEqualTo: userId)
          .orderBy('lastMessageTime', descending: true)
          .get();

      final chatMap = <String, ChatModel>{};
      for (final doc in buyerSnapshot.docs) {
          chatMap[doc.id] = ChatModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }
      for (final doc in sellerSnapshot.docs) {
        if (!chatMap.containsKey(doc.id)) {
        chatMap[doc.id] = ChatModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        }
      }

      final chats = chatMap.values.toList();
      chats.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      return chats;
    } on FirebaseException catch (e) {
      throw Exception('Failed to get chats: ${e.message}');
    }
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firebaseService.firestore
        .collection(FirebaseConfig.chatsCollection)
        .doc(chatId)
        .collection(FirebaseConfig.messagesCollection)
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  Future<void> markAsRead(String chatId, String userId) async {
    try {
      final chatDoc = await _firebaseService.firestore
          .collection(FirebaseConfig.chatsCollection)
          .doc(chatId)
          .get();

      if (!chatDoc.exists) return;

      final chat = ChatModel.fromJson(chatDoc.data()!, chatDoc.id);
      if (userId == chat.buyerId) {
        await chatDoc.reference.update({'isReadByBuyer': true});
      } else if (userId == chat.sellerId) {
        await chatDoc.reference.update({'isReadBySeller': true});
      }
    } on FirebaseException catch (e) {
      throw Exception('Failed to mark as read: ${e.message}');
    }
  }

  Future<String> uploadChatImage(File image, String chatId) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _firebaseService.storage
          .ref()
          .child('${FirebaseConfig.chatStorage}/$chatId/$fileName');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Failed to upload image: ${e.message}');
    }
  }

  Future<ChatModel?> getChatById(String chatId) async {
    try {
      final doc = await _firebaseService.firestore
          .collection(FirebaseConfig.chatsCollection)
          .doc(chatId)
          .get();

      if (!doc.exists) return null;
      return ChatModel.fromJson(doc.data()!, doc.id);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get chat: ${e.message}');
    }
  }

  Future<DocumentSnapshot?> getExistingChat(String buyerId, String sellerId, String adId) async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.chatsCollection)
          .where('buyerId', isEqualTo: buyerId)
          .where('sellerId', isEqualTo: sellerId)
          .where('adId', isEqualTo: adId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return snapshot.docs.first;
    } on FirebaseException catch (e) {
      throw Exception('Failed to find existing chat: ${e.message}');
    }
  }
}
