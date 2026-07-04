import '../repositories/admin_repository.dart';

class ManageCities {
  final AdminRepository repository;
  ManageCities(this.repository);

  Future<void> call(Map<String, dynamic> data) {
    return repository.manageCities(data);
  }
}
