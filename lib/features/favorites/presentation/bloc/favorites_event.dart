import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class AddFavorite extends FavoritesEvent {
  final String adId;

  const AddFavorite(this.adId);

  @override
  List<Object?> get props => [adId];
}

class RemoveFavorite extends FavoritesEvent {
  final String adId;

  const RemoveFavorite(this.adId);

  @override
  List<Object?> get props => [adId];
}

class CheckFavorite extends FavoritesEvent {
  final String adId;

  const CheckFavorite(this.adId);

  @override
  List<Object?> get props => [adId];
}
