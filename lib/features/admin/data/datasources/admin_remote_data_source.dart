import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/firebase_config.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../ads/data/models/ad_model.dart';
import '../../../categories/data/models/category_model.dart';
import '../../../reports/data/models/report_model.dart';
import '../../data/models/statistics_model.dart';

class AdminRemoteDataSource {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<AdModel>> getPendingAds() async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AdModel.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get pending ads: ${e.message}');
    }
  }

  Future<void> approveAd(String adId) async {
    try {
      await _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .doc(adId)
          .update({
        'status': 'approved',
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to approve ad: ${e.message}');
    }
  }

  Future<void> rejectAd(String adId, String reason) async {
    try {
      await _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .doc(adId)
          .update({
        'status': 'rejected',
        'rejectReason': reason,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to reject ad: ${e.message}');
    }
  }

  Future<void> blockUser(String userId) async {
    try {
      await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(userId)
          .update({
        'isActive': false,
        'lastSeen': Timestamp.fromDate(DateTime.now()),
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to block user: ${e.message}');
    }
  }

  Future<void> unblockUser(String userId) async {
    try {
      await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(userId)
          .update({
        'isActive': true,
        'lastSeen': Timestamp.fromDate(DateTime.now()),
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to unblock user: ${e.message}');
    }
  }

  Future<List<ReportModel>> getReports() async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.reportsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReportModel.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get reports: ${e.message}');
    }
  }

  Future<void> sendBulkNotification(String title, String body) async {
    try {
      final usersSnapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .get();

      final batch = _firebaseService.firestore.batch();
      for (final userDoc in usersSnapshot.docs) {
        final notificationRef = _firebaseService.firestore
            .collection(FirebaseConfig.notificationsCollection)
            .doc();
        batch.set(notificationRef, {
          'userId': userDoc.id,
          'title': title,
          'body': body,
          'type': 'bulk',
          'isRead': false,
          'createdAt': Timestamp.fromDate(DateTime.now()),
        });
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception('Failed to send bulk notification: ${e.message}');
    }
  }

  Future<StatisticsModel> getStatistics() async {
    try {
      final usersCount = await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .count()
          .get();

      final adsSnapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .get();

      final pendingAds = adsSnapshot.docs
          .where((doc) => doc.data()['status'] == 'pending')
          .length;
      final approvedAds = adsSnapshot.docs
          .where((doc) => doc.data()['status'] == 'approved')
          .length;
      final rejectedAds = adsSnapshot.docs
          .where((doc) => doc.data()['status'] == 'rejected')
          .length;

      final totalViews = adsSnapshot.docs.fold<int>(
          0, (sum, doc) => sum + ((doc.data()['viewsCount'] as num?)?.toInt() ?? 0));

      final reportsCount = await _firebaseService.firestore
          .collection(FirebaseConfig.reportsCollection)
          .count()
          .get();

      final chatsCount = await _firebaseService.firestore
          .collection(FirebaseConfig.chatsCollection)
          .count()
          .get();

      final adsByCategory = <String, int>{};
      final adsByGovernorate = <String, int>{};
      final now = DateTime.now();
      final lastWeek = now.subtract(const Duration(days: 7));
      final lastWeekAds = List<int>.filled(7, 0);
      final lastWeekUsers = List<int>.filled(7, 0);

      for (final doc in adsSnapshot.docs) {
        final data = doc.data();
        final category = data['categoryName'] as String? ?? 'أخرى';
        adsByCategory[category] = (adsByCategory[category] ?? 0) + 1;

        final gov = data['governorate'] as String? ?? 'أخرى';
        adsByGovernorate[gov] = (adsByGovernorate[gov] ?? 0) + 1;

        final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
        if (createdAt != null && createdAt.isAfter(lastWeek)) {
          final dayIndex = now.difference(createdAt).inDays;
          if (dayIndex >= 0 && dayIndex < 7) {
            lastWeekAds[6 - dayIndex]++;
          }
        }
      }

      final usersSnapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .get();

      for (final doc in usersSnapshot.docs) {
        final createdAt = (doc.data()['createdAt'] as Timestamp?)?.toDate();
        if (createdAt != null && createdAt.isAfter(lastWeek)) {
          final dayIndex = now.difference(createdAt).inDays;
          if (dayIndex >= 0 && dayIndex < 7) {
            lastWeekUsers[6 - dayIndex]++;
          }
        }
      }

      return StatisticsModel(
        totalUsers: usersCount.count ?? 0,
        totalAds: adsSnapshot.docs.length,
        pendingAds: pendingAds,
        approvedAds: approvedAds,
        rejectedAds: rejectedAds,
        totalViews: totalViews,
        totalReports: reportsCount.count ?? 0,
        totalChats: chatsCount.count ?? 0,
        adsByCategory: adsByCategory,
        adsByGovernorate: adsByGovernorate,
        lastWeekAds: lastWeekAds,
        lastWeekUsers: lastWeekUsers,
      );
    } on FirebaseException catch (e) {
      throw Exception('Failed to get statistics: ${e.message}');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.categoriesCollection)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get categories: ${e.message}');
    }
  }

  Future<CategoryModel> addCategory(CategoryModel category) async {
    try {
      final docRef = _firebaseService.firestore
          .collection(FirebaseConfig.categoriesCollection)
          .doc(category.id);

      await docRef.set(category.toJson());
      return category;
    } on FirebaseException catch (e) {
      throw Exception('Failed to add category: ${e.message}');
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    try {
      await _firebaseService.firestore
          .collection(FirebaseConfig.categoriesCollection)
          .doc(category.id)
          .update(category.toJson());
    } on FirebaseException catch (e) {
      throw Exception('Failed to update category: ${e.message}');
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firebaseService.firestore
          .collection(FirebaseConfig.categoriesCollection)
          .doc(categoryId)
          .delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete category: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> getGovernorates() async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.governoratesCollection)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get governorates: ${e.message}');
    }
  }

  Future<void> addGovernorate(String name) async {
    try {
      final docRef = _firebaseService.firestore
          .collection(FirebaseConfig.governoratesCollection)
          .doc();
      await docRef.set({'name': name});
    } on FirebaseException catch (e) {
      throw Exception('Failed to add governorate: ${e.message}');
    }
  }

  Future<void> deleteGovernorate(String governorateId) async {
    try {
      await _firebaseService.firestore
          .collection(FirebaseConfig.governoratesCollection)
          .doc(governorateId)
          .delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete governorate: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> getCities(String governorateId) async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.governoratesCollection)
          .doc(governorateId)
          .collection(FirebaseConfig.citiesCollection)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get cities: ${e.message}');
    }
  }

  Future<void> addCity(String governorateId, String name) async {
    try {
      final docRef = _firebaseService.firestore
          .collection(FirebaseConfig.governoratesCollection)
          .doc(governorateId)
          .collection(FirebaseConfig.citiesCollection)
          .doc();
      await docRef.set({'name': name});
    } on FirebaseException catch (e) {
      throw Exception('Failed to add city: ${e.message}');
    }
  }

  Future<void> deleteCity(String governorateId, String cityId) async {
    try {
      await _firebaseService.firestore
          .collection(FirebaseConfig.governoratesCollection)
          .doc(governorateId)
          .collection(FirebaseConfig.citiesCollection)
          .doc(cityId)
          .delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete city: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get users: ${e.message}');
    }
  }
}
