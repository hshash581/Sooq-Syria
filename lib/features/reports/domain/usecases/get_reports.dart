import '../../domain/entities/report_entity.dart';
import '../repositories/reports_repository.dart';

class GetReports {
  final ReportsRepository repository;
  GetReports(this.repository);

  Future<List<ReportEntity>> call() {
    return repository.getReports();
  }
}
