import '../../../ads/domain/entities/ad_entity.dart';
import '../repositories/home_repository.dart';

class GetFeaturedAds {
  final HomeRepository repository;
  GetFeaturedAds(this.repository);

  Future<List<AdEntity>> call() {
    return repository.getFeaturedAds();
  }
}
