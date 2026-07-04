import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../ads/domain/entities/ad_entity.dart';
import '../../../reports/domain/entities/report_entity.dart';
import '../../domain/entities/statistics_entity.dart';

abstract class AdminRepository {
  Future<List<AdEntity>> getPendingAds({DocumentSnapshot? lastDoc});
  Future<void> approveAd(String adId);
  Future<void> rejectAd(String adId, {String? reason});
  Future<void> blockUser(String userId);
  Future<void> unblockUser(String userId);
  Future<List<ReportEntity>> getReports({DocumentSnapshot? lastDoc});
  Future<void> sendBulkNotification(String title, String body);
  Future<StatisticsEntity> getStatistics();
  Future<void> manageCategories(Map<String, dynamic> data);
  Future<void> manageGovernorates(Map<String, dynamic> data);
  Future<void> manageCities(Map<String, dynamic> data);
}
