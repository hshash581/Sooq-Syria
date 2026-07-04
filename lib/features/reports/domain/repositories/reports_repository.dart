import '../../domain/entities/report_entity.dart';

abstract class ReportsRepository {
  Future<void> createReport(ReportEntity report);
  Future<List<ReportEntity>> getReports();
}
