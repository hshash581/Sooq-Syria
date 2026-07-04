import '../../domain/entities/report_entity.dart';
import '../repositories/reports_repository.dart';

class CreateReport {
  final ReportsRepository repository;
  CreateReport(this.repository);

  Future<void> call(ReportEntity report) {
    return repository.createReport(report);
  }
}
