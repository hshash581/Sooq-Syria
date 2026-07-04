import '../../../../core/services/firebase_service.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  final FirebaseService _firebaseService = FirebaseService();

  NotificationsRepositoryImpl({required this.remoteDataSource});

  String get _userId => _firebaseService.auth.currentUser?.uid ?? '';

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    try {
      final models = await remoteDataSource.getNotifications(_userId);
      return models.map((model) => NotificationEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead(_userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await remoteDataSource.deleteNotification(notificationId);
    } catch (e) {
      rethrow;
    }
  }
}
