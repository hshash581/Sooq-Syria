import '../../../ads/domain/entities/ad_entity.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites {
  final FavoritesRepository repository;
  GetFavorites(this.repository);

  Future<List<AdEntity>> call() {
    return repository.getFavorites();
  }
}
