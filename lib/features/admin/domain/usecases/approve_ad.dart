import '../repositories/admin_repository.dart';

class ApproveAd {
  final AdminRepository repository;
  ApproveAd(this.repository);

  Future<void> call(String adId) {
    return repository.approveAd(adId);
  }
}
