import '../repositories/favorites_repository.dart';

class AddFavorite {
  final FavoritesRepository repository;
  AddFavorite(this.repository);

  Future<void> call(String adId) {
    return repository.addFavorite(adId);
  }
}
