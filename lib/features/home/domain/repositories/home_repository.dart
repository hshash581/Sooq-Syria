import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../ads/domain/entities/ad_entity.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../domain/entities/banner_entity.dart';

abstract class HomeRepository {
  Future<List<BannerEntity>> getBanners();
  Future<List<CategoryEntity>> getCategories();
  Future<List<AdEntity>> getLatestAds({DocumentSnapshot? lastDoc});
  Future<List<AdEntity>> getFeaturedAds();
  Future<List<AdEntity>> getMostViewedAds({DocumentSnapshot? lastDoc});
}
