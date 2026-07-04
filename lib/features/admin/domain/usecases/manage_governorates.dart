import '../repositories/admin_repository.dart';

class ManageGovernorates {
  final AdminRepository repository;
  ManageGovernorates(this.repository);

  Future<void> call(Map<String, dynamic> data) {
    return repository.manageGovernorates(data);
  }
}
