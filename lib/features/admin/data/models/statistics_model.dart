import 'package:equatable/equatable.dart';

class StatisticsModel extends Equatable {
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

  const StatisticsModel({
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

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      totalUsers: (json['totalUsers'] as num?)?.toInt() ?? 0,
      totalAds: (json['totalAds'] as num?)?.toInt() ?? 0,
      pendingAds: (json['pendingAds'] as num?)?.toInt() ?? 0,
      approvedAds: (json['approvedAds'] as num?)?.toInt() ?? 0,
      rejectedAds: (json['rejectedAds'] as num?)?.toInt() ?? 0,
      totalViews: (json['totalViews'] as num?)?.toInt() ?? 0,
      totalReports: (json['totalReports'] as num?)?.toInt() ?? 0,
      totalChats: (json['totalChats'] as num?)?.toInt() ?? 0,
      adsByCategory: Map<String, int>.from((json['adsByCategory'] as Map<dynamic, dynamic>?)?.map(
        (k, v) => MapEntry(k as String, (v as num).toInt()),
      ) ?? {}),
      adsByGovernorate: Map<String, int>.from((json['adsByGovernorate'] as Map<dynamic, dynamic>?)?.map(
        (k, v) => MapEntry(k as String, (v as num).toInt()),
      ) ?? {}),
      lastWeekAds: (json['lastWeekAds'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? [],
      lastWeekUsers: (json['lastWeekUsers'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'totalAds': totalAds,
      'pendingAds': pendingAds,
      'approvedAds': approvedAds,
      'rejectedAds': rejectedAds,
      'totalViews': totalViews,
      'totalReports': totalReports,
      'totalChats': totalChats,
      'adsByCategory': adsByCategory,
      'adsByGovernorate': adsByGovernorate,
      'lastWeekAds': lastWeekAds,
      'lastWeekUsers': lastWeekUsers,
    };
  }

  StatisticsModel copyWith({
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
    return StatisticsModel(
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

  @override
  List<Object?> get props => [totalUsers, totalAds, pendingAds];
}
