import '../repositories/admin_repository.dart';

class BlockUser {
  final AdminRepository repository;
  BlockUser(this.repository);

  Future<void> call(String userId) {
    return repository.blockUser(userId);
  }
}
