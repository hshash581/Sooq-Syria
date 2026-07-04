import 'package:equatable/equatable.dart';
import '../../data/models/statistics_model.dart';

class StatisticsEntity extends Equatable {
  final int totalUsers;
  final int totalAds;
  final int pendingAds;
  final int approvedAds;
  final int rejectedAds;
  final int totalViews;
  final int totalReports;
  final int totalChats;
  final Map<String, int> adsByCategory;
  final Map<String, int> adsByGovernorate;
  final List<int> lastWeekAds;
  final List<int> lastWeekUsers;

  const StatisticsEntity({
    this.totalUsers = 0,
    this.totalAds = 0,
    this.pendingAds = 0,
    this.approvedAds = 0,
    this.rejectedAds = 0,
    this.totalViews = 0,
    this.totalReports = 0,
    this.totalChats = 0,
    this.adsByCategory = const {},
    this.adsByGovernorate = const {},
    this.lastWeekAds = const [],
    this.lastWeekUsers = const [],
  });

  StatisticsEntity copyWith({
    int? totalUsers,
    int? totalAds,
    int? pendingAds,
    int? approvedAds,
    int? rejectedAds,
    int? totalViews,
    int? totalReports,
    int? totalChats,
    Map<String, int>? adsByCategory,
    Map<String, int>? adsByGovernorate,
    List<int>? lastWeekAds,
    List<int>? lastWeekUsers,
  }) {
    return StatisticsEntity(
      totalUsers: totalUsers ?? this.totalUsers,
      totalAds: totalAds ?? this.totalAds,
      pendingAds: pendingAds ?? this.pendingAds,
      approvedAds: approvedAds ?? this.approvedAds,
      rejectedAds: rejectedAds ?? this.rejectedAds,
      totalViews: totalViews ?? this.totalViews,
      totalReports: totalReports ?? this.totalReports,
      totalChats: totalChats ?? this.totalChats,
      adsByCategory: adsByCategory ?? this.adsByCategory,
      adsByGovernorate: adsByGovernorate ?? this.adsByGovernorate,
      lastWeekAds: lastWeekAds ?? this.lastWeekAds,
      lastWeekUsers: lastWeekUsers ?? this.lastWeekUsers,
    );
  }

  factory StatisticsEntity.fromModel(StatisticsModel model) {
    return StatisticsEntity(
      totalUsers: model.totalUsers,
      totalAds: model.totalAds,
      pendingAds: model.pendingAds,
      approvedAds: model.approvedAds,
      rejectedAds: model.rejectedAds,
      totalViews: model.totalViews,
      totalReports: model.totalReports,
      totalChats: model.totalChats,
      adsByCategory: Map<String, int>.from(model.adsByCategory),
      adsByGovernorate: Map<String, int>.from(model.adsByGovernorate),
      lastWeekAds: List<int>.from(model.lastWeekAds),
      lastWeekUsers: List<int>.from(model.lastWeekUsers),
    );
  }

  StatisticsModel toModel() {
    return StatisticsModel(
      totalUsers: totalUsers,
      totalAds: totalAds,
      pendingAds: pendingAds,
      approvedAds: approvedAds,
      rejectedAds: rejectedAds,
      totalViews: totalViews,
      totalReports: totalReports,
      totalChats: totalChats,
      adsByCategory: Map<String, int>.from(adsByCategory),
      adsByGovernorate: Map<String, int>.from(adsByGovernorate),
      lastWeekAds: List<int>.from(lastWeekAds),
      lastWeekUsers: List<int>.from(lastWeekUsers),
    );
  }

  @override
  List<Object?> get props => [totalUsers, totalAds, pendingAds];
}
