import '../../domain/entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class GetAdsByUser {
  final AdsRepository repository;
  GetAdsByUser(this.repository);

  Future<List<AdEntity>> call(String userId) {
    return repository.getAdsByUser(userId);
  }
}
