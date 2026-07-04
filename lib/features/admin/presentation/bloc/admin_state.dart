import 'package:equatable/equatable.dart';

import '../../../ads/domain/entities/ad_entity.dart';
import '../../../admin/domain/entities/statistics_entity.dart';
import '../../../reports/domain/entities/report_entity.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {
  const AdminInitial();
}

class AdminLoading extends AdminState {
  const AdminLoading();
}

class AdminDashboardLoaded extends AdminState {
  final StatisticsEntity statistics;
  final int pendingAdsCount;
  final int usersCount;

  const AdminDashboardLoaded({
    required this.statistics,
    required this.pendingAdsCount,
    required this.usersCount,
  });

  @override
  List<Object?> get props => [statistics, pendingAdsCount, usersCount];
}

class AdminPendingAdsLoaded extends AdminState {
  final List<AdEntity> ads;

  const AdminPendingAdsLoaded(this.ads);

  @override
  List<Object?> get props => [ads];
}

class AdminUsersLoaded extends AdminState {
  final List<dynamic> users;

  const AdminUsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class AdminReportsLoaded extends AdminState {
  final List<ReportEntity> reports;

  const AdminReportsLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

class AdminNotificationSent extends AdminState {
  const AdminNotificationSent();
}

class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);

  @override
  List<Object?> get props => [message];
}
