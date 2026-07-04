import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<MessageEntity> sendMessage(String chatId, String text,
      {File? image});
  Future<List<ChatEntity>> getChats();
  Future<List<MessageEntity>> getMessages(String chatId,
      {DocumentSnapshot? lastDoc});
  Future<ChatEntity> createChat(String adId, String sellerId);
  Future<void> markAsRead(String chatId);
}
