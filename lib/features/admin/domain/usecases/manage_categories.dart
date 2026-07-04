import '../repositories/admin_repository.dart';

class ManageCategories {
  final AdminRepository repository;
  ManageCategories(this.repository);

  Future<void> call(Map<String, dynamic> data) {
    return repository.manageCategories(data);
  }
}
