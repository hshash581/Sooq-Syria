import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/reports_repository.dart';
import 'reports_event.dart';
import 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final ReportsRepository _reportsRepository;

  ReportsBloc({required ReportsRepository reportsRepository})
      : _reportsRepository = reportsRepository,
        super(const ReportsInitial()) {
    on<CreateReport>(_onCreateReport);
    on<LoadReports>(_onLoadReports);
  }

  Future<void> _onCreateReport(
      CreateReport event, Emitter<ReportsState> emit) async {
    emit(const ReportsLoading());
    try {
      final report = ReportEntity(
        id: '',
        reporterId: '',
        adId: event.adId,
        reason: event.reason,
        description: event.description,
      );
      await _reportsRepository.createReport(report);
      emit(const ReportsSuccess());
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> _onLoadReports(
      LoadReports event, Emitter<ReportsState> emit) async {
    emit(const ReportsLoading());
    try {
      final reports = await _reportsRepository.getReports();
      emit(ReportsLoaded(reports));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }
}
