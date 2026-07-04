import '../../domain/entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class CreateChat {
  final ChatRepository repository;
  CreateChat(this.repository);

  Future<ChatEntity> call(String adId, String sellerId) {
    return repository.createChat(adId, sellerId);
  }
}
