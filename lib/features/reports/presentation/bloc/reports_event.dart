import 'package:equatable/equatable.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

class CreateReport extends ReportsEvent {
  final String adId;
  final String reason;
  final String description;

  const CreateReport(this.adId, this.reason, this.description);

  @override
  List<Object?> get props => [adId, reason, description];
}

class LoadReports extends ReportsEvent {
  const LoadReports();
}
