import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;
  GetMessages(this.repository);

  Future<List<MessageEntity>> call(String chatId,
      {DocumentSnapshot? lastDoc}) {
    return repository.getMessages(chatId, lastDoc: lastDoc);
  }
}
