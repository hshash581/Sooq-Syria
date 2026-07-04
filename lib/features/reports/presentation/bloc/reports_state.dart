import 'package:equatable/equatable.dart';

import '../../../reports/domain/entities/report_entity.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {
  const ReportsInitial();
}

class ReportsLoading extends ReportsState {
  const ReportsLoading();
}

class ReportsSuccess extends ReportsState {
  const ReportsSuccess();
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ReportsLoaded extends ReportsState {
  final List<ReportEntity> reports;

  const ReportsLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}
