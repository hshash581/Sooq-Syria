import '../../domain/entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetChats {
  final ChatRepository repository;
  GetChats(this.repository);

  Future<List<ChatEntity>> call() {
    return repository.getChats();
  }
}
