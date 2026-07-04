import '../repositories/chat_repository.dart';

class MarkAsRead {
  final ChatRepository repository;
  MarkAsRead(this.repository);

  Future<void> call(String chatId) {
    return repository.markAsRead(chatId);
  }
}
