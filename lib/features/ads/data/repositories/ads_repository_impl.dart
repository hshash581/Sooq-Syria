import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/services/firebase_service.dart';
import '../../domain/entities/ad_entity.dart';
import '../../domain/repositories/ads_repository.dart';
import '../datasources/ads_remote_data_source.dart';

class AdsRepositoryImpl implements AdsRepository {
  final AdsRemoteDataSource remoteDataSource;
  final FirebaseService _firebaseService = FirebaseService();

  AdsRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<QuerySnapshot> get adsStream {
    return _firebaseService.firestore
        .collection(FirebaseConfig.adsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Future<AdEntity> createAd(AdEntity ad, List<File> images) async {
    try {
      final model = ad.toModel();
      final result = await remoteDataSource.createAd(model, images);
      return AdEntity.fromModel(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AdEntity> updateAd(AdEntity ad,
      {List<File>? newImages, List<String>? deletedImages}) async {
    try {
      var model = ad.toModel();

      if (deletedImages != null && deletedImages.isNotEmpty) {
        model = model.copyWith(
          images: model.images
              .where((img) => !deletedImages.contains(img))
              .toList(),
        );
      }

      final result = await remoteDataSource.updateAd(model, newImages);
      return AdEntity.fromModel(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAd(String adId) async {
    try {
      await remoteDataSource.deleteAd(adId, '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AdEntity> getAdById(String adId) async {
    try {
      final model = await remoteDataSource.getAd(adId);
      return AdEntity.fromModel(model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AdEntity>> getAdsByUser(String userId,
      {DocumentSnapshot? lastDoc}) async {
    try {
      final models = await remoteDataSource.getAdsByUser(userId, lastDoc: lastDoc);
      return models.map((model) => AdEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AdEntity>> getAdsByCategory(String categoryId,
      {DocumentSnapshot? lastDoc}) async {
    try {
      final models =
          await remoteDataSource.getAdsByCategory(categoryId, lastDoc: lastDoc);
      return models.map((model) => AdEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AdEntity>> getLatestAds({DocumentSnapshot? lastDoc}) async {
    try {
      final models = await remoteDataSource.getLatestAds(lastDoc: lastDoc);
      return models.map((model) => AdEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AdEntity>> getFeaturedAds() async {
    try {
      final models = await remoteDataSource.getFeaturedAds();
      return models.map((model) => AdEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AdEntity>> getMostViewedAds({DocumentSnapshot? lastDoc}) async {
    try {
      final models = await remoteDataSource.getMostViewedAds(lastDoc: lastDoc);
      return models.map((model) => AdEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AdEntity> toggleAdStatus(String adId) async {
    try {
      final model = await remoteDataSource.getAd(adId);
      final newStatus = model.status == 'approved' ? 'pending' : 'approved';
      final updated = model.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      await remoteDataSource.updateAd(updated, null);
      return AdEntity.fromModel(updated);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AdEntity> renewAd(String adId) async {
    try {
      final model = await remoteDataSource.getAd(adId);
      final expiresAt = DateTime.now().add(const Duration(days: 30));
      final updated = model.copyWith(
        status: 'approved',
        expiresAt: expiresAt,
        updatedAt: DateTime.now(),
      );
      await remoteDataSource.updateAd(updated, null);
      return AdEntity.fromModel(updated);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> incrementViews(String adId) async {
    try {
      await remoteDataSource.incrementViews(adId);
    } catch (e) {
      rethrow;
    }
  }
}
