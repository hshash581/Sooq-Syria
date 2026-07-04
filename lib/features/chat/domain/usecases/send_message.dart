import 'dart:io';

import '../../domain/entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;
  SendMessage(this.repository);

  Future<MessageEntity> call(String chatId, String text, {File? image}) {
    return repository.sendMessage(chatId, text, image: image);
  }
}
