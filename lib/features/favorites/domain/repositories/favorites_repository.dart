import '../../../ads/domain/entities/ad_entity.dart';

abstract class FavoritesRepository {
  Future<void> addFavorite(String adId);
  Future<void> removeFavorite(String adId);
  Future<List<AdEntity>> getFavorites();
  Future<bool> isFavorite(String adId);
}
