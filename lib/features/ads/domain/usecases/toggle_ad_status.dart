import '../../domain/entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class ToggleAdStatus {
  final AdsRepository repository;
  ToggleAdStatus(this.repository);

  Future<AdEntity> call(String adId) {
    return repository.toggleAdStatus(adId);
  }
}
