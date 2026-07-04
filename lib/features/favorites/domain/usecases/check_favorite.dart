import '../repositories/favorites_repository.dart';

class CheckFavorite {
  final FavoritesRepository repository;
  CheckFavorite(this.repository);

  Future<bool> call(String adId) {
    return repository.isFavorite(adId);
  }
}
