import '../../domain/entities/notification_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotifications {
  final NotificationsRepository repository;
  GetNotifications(this.repository);

  Future<List<NotificationEntity>> call() {
    return repository.getNotifications();
  }
}
