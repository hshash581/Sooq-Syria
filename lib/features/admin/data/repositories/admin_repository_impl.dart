import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../ads/domain/entities/ad_entity.dart';
import '../../../categories/data/models/category_model.dart';
import '../../../reports/domain/entities/report_entity.dart';
import '../../domain/entities/statistics_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AdEntity>> getPendingAds({DocumentSnapshot? lastDoc}) async {
    try {
      final models = await remoteDataSource.getPendingAds();
      return models.map((model) => AdEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> approveAd(String adId) async {
    try {
      await remoteDataSource.approveAd(adId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> rejectAd(String adId, {String? reason}) async {
    try {
      await remoteDataSource.rejectAd(adId, reason ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> blockUser(String userId) async {
    try {
      await remoteDataSource.blockUser(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unblockUser(String userId) async {
    try {
      await remoteDataSource.unblockUser(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ReportEntity>> getReports({DocumentSnapshot? lastDoc}) async {
    try {
      final models = await remoteDataSource.getReports();
      return models.map((model) => ReportEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendBulkNotification(String title, String body) async {
    try {
      await remoteDataSource.sendBulkNotification(title, body);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<StatisticsEntity> getStatistics() async {
    try {
      final model = await remoteDataSource.getStatistics();
      return StatisticsEntity.fromModel(model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> manageCategories(Map<String, dynamic> data) async {
    try {
      final action = data['action'] as String?;
      if (action == 'add') {
        final category = CategoryModel(
          id: data['id'] as String? ?? '',
          name: data['name'] as String? ?? '',
          icon: data['icon'] as String?,
          image: data['image'] as String?,
          color: data['color'] as String?,
          order: data['order'] as int? ?? 0,
          isActive: data['isActive'] as bool? ?? true,
        );
        await remoteDataSource.addCategory(category);
      } else if (action == 'update') {
        final category = CategoryModel(
          id: data['id'] as String? ?? '',
          name: data['name'] as String? ?? '',
          icon: data['icon'] as String?,
          image: data['image'] as String?,
          color: data['color'] as String?,
          order: data['order'] as int? ?? 0,
          isActive: data['isActive'] as bool? ?? true,
        );
        await remoteDataSource.updateCategory(category);
      } else if (action == 'delete') {
        await remoteDataSource.deleteCategory(data['id'] as String? ?? '');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> manageGovernorates(Map<String, dynamic> data) async {
    try {
      final action = data['action'] as String?;
      if (action == 'add') {
        await remoteDataSource.addGovernorate(data['name'] as String? ?? '');
      } else if (action == 'delete') {
        await remoteDataSource.deleteGovernorate(data['id'] as String? ?? '');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> manageCities(Map<String, dynamic> data) async {
    try {
      final action = data['action'] as String?;
      final governorateId = data['governorateId'] as String? ?? '';
      if (action == 'add') {
        await remoteDataSource.addCity(governorateId, data['name'] as String? ?? '');
      } else if (action == 'delete') {
        await remoteDataSource.deleteCity(
          governorateId,
          data['cityId'] as String? ?? '',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
