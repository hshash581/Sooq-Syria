import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../ads/data/models/ad_model.dart';
import '../../../ads/domain/entities/ad_entity.dart';
import '../../../categories/data/datasources/categories_remote_data_source.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/banner_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final CategoriesRemoteDataSource categoriesDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.categoriesDataSource,
  });

  @override
  Future<List<BannerEntity>> getBanners() async {
    try {
      final models = await remoteDataSource.getBanners();
      return models.map((model) => BannerEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final models = await categoriesDataSource.getCategories();
      return models.map((model) => CategoryEntity.fromModel(model)).toList();
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
}
