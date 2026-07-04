import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/firebase_config.dart';
import '../../../../core/services/firebase_service.dart';
import '../../data/models/notification_model.dart';

class NotificationsRemoteDataSource {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.notificationsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get notifications: ${e.message}');
    }
  }

  Stream<List<NotificationModel>> streamNotifications(String userId) {
    return _firebaseService.firestore
        .collection(FirebaseConfig.notificationsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _firebaseService.firestore
          .collection(FirebaseConfig.notificationsCollection)
          .doc(notificationId)
          .update({'isRead': true});
    } on FirebaseException catch (e) {
      throw Exception('Failed to mark notification as read: ${e.message}');
    }
  }

  Future<void> markAllAsRead(String userId) async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.notificationsCollection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firebaseService.firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception('Failed to mark all as read: ${e.message}');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firebaseService.firestore
          .collection(FirebaseConfig.notificationsCollection)
          .doc(notificationId)
          .delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete notification: ${e.message}');
    }
  }

  Future<NotificationModel> createNotification(NotificationModel notification) async {
    try {
      final docRef = _firebaseService.firestore
          .collection(FirebaseConfig.notificationsCollection)
          .doc(notification.id);

      await docRef.set(notification.toJson());
      return notification;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create notification: ${e.message}');
    }
  }

  Future<int> getUnreadCount(String userId) async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.notificationsCollection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .count()
          .get();

      return snapshot.count ?? 0;
    } on FirebaseException catch (e) {
      throw Exception('Failed to get unread count: ${e.message}');
    }
  }
}
