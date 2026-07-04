import '../../domain/entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class RenewAd {
  final AdsRepository repository;
  RenewAd(this.repository);

  Future<AdEntity> call(String adId) {
    return repository.renewAd(adId);
  }
}
