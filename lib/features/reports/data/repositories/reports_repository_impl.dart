import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_remote_data_source.dart';
import '../models/report_model.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource remoteDataSource;

  ReportsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createReport(ReportEntity report) async {
    try {
      final model = report.toModel();
      await remoteDataSource.createReport(model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ReportEntity>> getReports() async {
    try {
      final models = await remoteDataSource.getReports();
      return models.map((model) => ReportEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
