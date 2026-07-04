import '../repositories/admin_repository.dart';

class RejectAd {
  final AdminRepository repository;
  RejectAd(this.repository);

  Future<void> call(String adId, {String? reason}) {
    return repository.rejectAd(adId, reason: reason);
  }
}
