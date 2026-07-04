import '../repositories/notifications_repository.dart';

class DeleteNotification {
  final NotificationsRepository repository;
  DeleteNotification(this.repository);

  Future<void> call(String notificationId) {
    return repository.deleteNotification(notificationId);
  }
}
