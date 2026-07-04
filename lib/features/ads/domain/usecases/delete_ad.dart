import '../repositories/ads_repository.dart';

class DeleteAd {
  final AdsRepository repository;
  DeleteAd(this.repository);

  Future<void> call(String adId) {
    return repository.deleteAd(adId);
  }
}
