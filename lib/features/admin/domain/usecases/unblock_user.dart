import '../repositories/admin_repository.dart';

class UnblockUser {
  final AdminRepository repository;
  UnblockUser(this.repository);

  Future<void> call(String userId) {
    return repository.unblockUser(userId);
  }
}
