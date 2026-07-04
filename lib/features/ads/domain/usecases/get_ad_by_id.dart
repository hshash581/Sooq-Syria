import '../../domain/entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class GetAdById {
  final AdsRepository repository;
  GetAdById(this.repository);

  Future<AdEntity> call(String adId) {
    return repository.getAdById(adId);
  }
}
