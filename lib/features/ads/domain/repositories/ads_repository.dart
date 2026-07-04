import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/ad_entity.dart';

abstract class AdsRepository {
  Future<AdEntity> createAd(AdEntity ad, List<File> images);
  Future<AdEntity> updateAd(AdEntity ad,
      {List<File>? newImages, List<String>? deletedImages});
  Future<void> deleteAd(String adId);
  Future<AdEntity> getAdById(String adId);
  Future<List<AdEntity>> getAdsByUser(String userId);
  Future<List<AdEntity>> getAdsByCategory(String categoryId,
      {DocumentSnapshot? lastDoc});
  Future<List<AdEntity>> getLatestAds({DocumentSnapshot? lastDoc});
  Future<List<AdEntity>> getFeaturedAds();
  Future<List<AdEntity>> getMostViewedAds({DocumentSnapshot? lastDoc});
  Future<AdEntity> toggleAdStatus(String adId);
  Future<AdEntity> renewAd(String adId);
  Future<void> incrementViews(String adId);
  Stream<QuerySnapshot> get adsStream;
}
