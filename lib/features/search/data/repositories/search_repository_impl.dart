import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../ads/domain/entities/ad_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AdEntity>> searchAds(String query,
      {DocumentSnapshot? lastDoc}) async {
    try {
      final models = await remoteDataSource.searchAds(
        query,
        lastDoc: lastDoc,
      );
      return models.map((model) => AdEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AdEntity>> searchAdsByFilters({
    String? categoryId,
    String? governorate,
    String? city,
    double? minPrice,
    double? maxPrice,
    String? condition,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      final filters = SearchFilters(
        categoryId: categoryId,
        governorate: governorate,
        city: city,
        minPrice: minPrice,
        maxPrice: maxPrice,
        isNew: condition != null ? condition == 'new' : null,
      );

      final models = await remoteDataSource.searchAds(
        '',
        filters: filters,
        lastDoc: lastDoc,
      );
      return models.map((model) => AdEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
