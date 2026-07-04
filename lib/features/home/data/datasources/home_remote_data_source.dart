import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/firebase_config.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../ads/data/models/ad_model.dart';
import '../../data/models/banner_model.dart';

class HomeRemoteDataSource {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<BannerModel>> getBanners() async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.bannersCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => BannerModel.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get banners: ${e.message}');
    }
  }

  Future<List<AdModel>> getLatestAds(
      {DocumentSnapshot? lastDoc, int limit = 20}) async {
    try {
      var query = _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .where('status', isEqualTo: 'approved')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => AdModel.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get latest ads: ${e.message}');
    }
  }

  Future<List<AdModel>> getFeaturedAds(
      {DocumentSnapshot? lastDoc, int limit = 20}) async {
    try {
      var query = _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .where('isFeatured', isEqualTo: true)
          .where('status', isEqualTo: 'approved')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => AdModel.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get featured ads: ${e.message}');
    }
  }

  Future<List<AdModel>> getMostViewedAds(
      {DocumentSnapshot? lastDoc, int limit = 20}) async {
    try {
      var query = _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .where('status', isEqualTo: 'approved')
          .orderBy('viewsCount', descending: true)
          .limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => AdModel.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get most viewed ads: ${e.message}');
    }
  }
}
