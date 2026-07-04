import '../repositories/admin_repository.dart';

class SendBulkNotification {
  final AdminRepository repository;
  SendBulkNotification(this.repository);

  Future<void> call(String title, String body) {
    return repository.sendBulkNotification(title, body);
  }
}
