import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/config/firebase_config.dart';
import '../../../../core/services/firebase_service.dart';
import '../../data/models/ad_model.dart';

class AdsRemoteDataSource {
  final FirebaseService _firebaseService = FirebaseService();

  Future<AdModel> createAd(AdModel ad, List<File> images) async {
    try {
      final imageUrls = await _uploadImages(images, ad.id);
      ad = ad.copyWith(images: imageUrls);

      final docRef = _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .doc(ad.id);
      await docRef.set(ad.toJson());

      await _updateUserAdsCount(ad.userId, 1);

      return ad;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create ad: ${e.message}');
    }
  }

  Future<AdModel> getAd(String adId) async {
    try {
      final doc = await _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .doc(adId)
          .get();

      if (!doc.exists) throw Exception('Ad not found');
      return AdModel.fromJson(doc.data()!, doc.id);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get ad: ${e.message}');
    }
  }

  Future<AdModel> updateAd(AdModel ad, List<File>? newImages) async {
    try {
      if (newImages != null && newImages.isNotEmpty) {
        final imageUrls = await _uploadImages(newImages, ad.id);
        ad = ad.copyWith(images: [...ad.images, ...imageUrls]);
      }

      await _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .doc(ad.id)
          .update(ad.copyWith(updatedAt: DateTime.now()).toJson());

      return ad;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update ad: ${e.message}');
    }
  }

  Future<void> deleteAd(String adId, String userId) async {
    try {
      final ad = await getAd(adId);

      for (final imageUrl in ad.images) {
        try {
          final ref = await _firebaseService.storage.refFromURL(imageUrl);
          await ref.delete();
        } catch (_) {}
      }

      await _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .doc(adId)
          .delete();

      await _updateUserAdsCount(userId, -1);
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete ad: ${e.message}');
    }
  }

  Future<List<AdModel>> getAdsByUser(String userId,
      {DocumentSnapshot? lastDoc, int limit = 20}) async {
    try {
      var query = _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .where('userId', isEqualTo: userId)
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
      throw Exception('Failed to get user ads: ${e.message}');
    }
  }

  Future<List<AdModel>> getAdsByCategory(String categoryId,
      {DocumentSnapshot? lastDoc, int limit = 20}) async {
    try {
      var query = _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .where('categoryId', isEqualTo: categoryId)
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
      throw Exception('Failed to get category ads: ${e.message}');
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

  Future<void> incrementViews(String adId) async {
    try {
      await _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .doc(adId)
          .update({
        'viewsCount': FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to increment views: ${e.message}');
    }
  }

  Stream<AdModel> streamAd(String adId) {
    return _firebaseService.firestore
        .collection(FirebaseConfig.adsCollection)
        .doc(adId)
        .snapshots()
        .map((snapshot) => AdModel.fromJson(snapshot.data()!, snapshot.id));
  }

  Future<List<String>> _uploadImages(List<File> images, String adId) async {
    final urls = <String>[];
    for (int i = 0; i < images.length; i++) {
      try {
        final ref = _firebaseService.storage
            .ref()
            .child('${FirebaseConfig.adsStorage}/$adId/image_$i.jpg');
        await ref.putFile(images[i]);
        final url = await ref.getDownloadURL();
        urls.add(url);
      } on FirebaseException catch (e) {
        throw Exception('Failed to upload image $i: ${e.message}');
      }
    }
    return urls;
  }

  Future<void> _updateUserAdsCount(String userId, int increment) async {
    try {
      await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(userId)
          .update({'adsCount': FieldValue.increment(increment)});
    } catch (_) {}
  }
}
