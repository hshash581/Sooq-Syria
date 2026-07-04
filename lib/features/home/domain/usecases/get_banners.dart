import '../../domain/entities/banner_entity.dart';
import '../repositories/home_repository.dart';

class GetBanners {
  final HomeRepository repository;
  GetBanners(this.repository);

  Future<List<BannerEntity>> call() {
    return repository.getBanners();
  }
}
