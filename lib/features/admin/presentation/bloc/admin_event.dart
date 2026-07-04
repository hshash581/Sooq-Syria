import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends AdminEvent {
  const LoadDashboard();
}

class LoadPendingAds extends AdminEvent {
  const LoadPendingAds();
}

class ApproveAd extends AdminEvent {
  final String adId;

  const ApproveAd(this.adId);

  @override
  List<Object?> get props => [adId];
}

class RejectAd extends AdminEvent {
  final String adId;
  final String reason;

  const RejectAd(this.adId, this.reason);

  @override
  List<Object?> get props => [adId, reason];
}

class BlockUser extends AdminEvent {
  final String userId;

  const BlockUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UnblockUser extends AdminEvent {
  final String userId;

  const UnblockUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadReports extends AdminEvent {
  const LoadReports();
}

class SendBulkNotification extends AdminEvent {
  final String title;
  final String body;

  const SendBulkNotification(this.title, this.body);

  @override
  List<Object?> get props => [title, body];
}

class LoadStatistics extends AdminEvent {
  const LoadStatistics();
}

class LoadUsers extends AdminEvent {
  const LoadUsers();
}

class ManageCategories extends AdminEvent {
  final Map<String, dynamic> data;

  const ManageCategories(this.data);

  @override
  List<Object?> get props => [data];
}

class ManageGovernorates extends AdminEvent {
  final Map<String, dynamic> data;

  const ManageGovernorates(this.data);

  @override
  List<Object?> get props => [data];
}

class ManageCities extends AdminEvent {
  final Map<String, dynamic> data;

  const ManageCities(this.data);

  @override
  List<Object?> get props => [data];
}
