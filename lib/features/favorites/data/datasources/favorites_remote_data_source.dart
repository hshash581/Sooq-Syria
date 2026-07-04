import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/firebase_config.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../ads/data/models/ad_model.dart';
import '../../data/models/favorite_model.dart';

class FavoritesRemoteDataSource {
  final FirebaseService _firebaseService = FirebaseService();

  Future<FavoriteModel> addFavorite(String userId, String adId) async {
    try {
      final docRef = _firebaseService.firestore
          .collection(FirebaseConfig.favoritesCollection)
          .doc();

      final favorite = FavoriteModel(
        id: docRef.id,
        userId: userId,
        adId: adId,
      );

      await docRef.set(favorite.toJson());

      await _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .doc(adId)
          .update({'likesCount': FieldValue.increment(1)});

      return favorite;
    } on FirebaseException catch (e) {
      throw Exception('Failed to add favorite: ${e.message}');
    }
  }

  Future<void> removeFavorite(String favoriteId) async {
    try {
      final doc = await _firebaseService.firestore
          .collection(FirebaseConfig.favoritesCollection)
          .doc(favoriteId)
          .get();

      if (doc.exists) {
        final adId = doc.data()!['adId'] as String;
        await _firebaseService.firestore
            .collection(FirebaseConfig.favoritesCollection)
            .doc(favoriteId)
            .delete();

        await _firebaseService.firestore
            .collection(FirebaseConfig.adsCollection)
            .doc(adId)
            .update({'likesCount': FieldValue.increment(-1)});
      }
    } on FirebaseException catch (e) {
      throw Exception('Failed to remove favorite: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.favoritesCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final favoritesWithAds = <Map<String, dynamic>>[];
      for (final doc in snapshot.docs) {
        final favorite = FavoriteModel.fromJson(doc.data(), doc.id);
        final adDoc = await _firebaseService.firestore
            .collection(FirebaseConfig.adsCollection)
            .doc(favorite.adId)
            .get();

        if (adDoc.exists) {
          final ad = AdModel.fromJson(adDoc.data()!, adDoc.id);
          favoritesWithAds.add({
            'favorite': favorite,
            'ad': ad,
          });
        }
      }
      return favoritesWithAds;
    } on FirebaseException catch (e) {
      throw Exception('Failed to get favorites: ${e.message}');
    }
  }

  Future<bool> checkFavorite(String userId, String adId) async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.favoritesCollection)
          .where('userId', isEqualTo: userId)
          .where('adId', isEqualTo: adId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw Exception('Failed to check favorite: ${e.message}');
    }
  }

  Future<String?> getFavoriteId(String userId, String adId) async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.favoritesCollection)
          .where('userId', isEqualTo: userId)
          .where('adId', isEqualTo: adId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return snapshot.docs.first.id;
    } on FirebaseException catch (e) {
      throw Exception('Failed to get favorite id: ${e.message}');
    }
  }
}
