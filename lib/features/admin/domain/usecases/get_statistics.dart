import '../../domain/entities/statistics_entity.dart';
import '../repositories/admin_repository.dart';

class GetStatistics {
  final AdminRepository repository;
  GetStatistics(this.repository);

  Future<StatisticsEntity> call() {
    return repository.getStatistics();
  }
}
