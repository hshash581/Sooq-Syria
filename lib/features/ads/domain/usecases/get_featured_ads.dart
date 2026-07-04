import '../../domain/entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class GetFeaturedAds {
  final AdsRepository repository;
  GetFeaturedAds(this.repository);

  Future<List<AdEntity>> call() {
    return repository.getFeaturedAds();
  }
}
