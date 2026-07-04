import '../repositories/notifications_repository.dart';

class MarkAsRead {
  final NotificationsRepository repository;
  MarkAsRead(this.repository);

  Future<void> call(String notificationId) {
    return repository.markAsRead(notificationId);
  }
}
