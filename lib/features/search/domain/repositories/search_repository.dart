import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../ads/domain/entities/ad_entity.dart';

abstract class SearchRepository {
  Future<List<AdEntity>> searchAds(String query,
      {DocumentSnapshot? lastDoc});
  Future<List<AdEntity>> searchAdsByFilters({
    String? categoryId,
    String? governorate,
    String? city,
    double? minPrice,
    double? maxPrice,
    String? condition,
    DocumentSnapshot? lastDoc,
  });
}
