import '../../../../core/services/firebase_service.dart';
import '../../../ads/data/models/ad_model.dart';
import '../../../ads/domain/entities/ad_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;
  final FirebaseService _firebaseService = FirebaseService();

  FavoritesRepositoryImpl({required this.remoteDataSource});

  String get _userId => _firebaseService.auth.currentUser?.uid ?? '';

  @override
  Future<void> addFavorite(String adId) async {
    try {
      await remoteDataSource.addFavorite(_userId, adId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFavorite(String adId) async {
    try {
      final favoriteId = await remoteDataSource.getFavoriteId(_userId, adId);
      if (favoriteId != null) {
        await remoteDataSource.removeFavorite(favoriteId);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AdEntity>> getFavorites() async {
    try {
      final data = await remoteDataSource.getFavorites(_userId);
      return data.map((map) {
        final ad = map['ad'] as AdModel;
        return AdEntity.fromModel(ad);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isFavorite(String adId) async {
    try {
      return await remoteDataSource.checkFavorite(_userId, adId);
    } catch (e) {
      rethrow;
    }
  }
}
