import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../domain/repositories/favorites_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesBloc({required FavoritesRepository favoritesRepository})
      : _favoritesRepository = favoritesRepository,
        super(const FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
    on<CheckFavorite>(_onCheckFavorite);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(const FavoritesLoading());
    try {
      final favorites = await _favoritesRepository.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onAddFavorite(
      AddFavorite event, Emitter<FavoritesState> emit) async {
    try {
      await _favoritesRepository.addFavorite(event.adId);
      final favorites = await _favoritesRepository.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onRemoveFavorite(
      RemoveFavorite event, Emitter<FavoritesState> emit) async {
    try {
      await _favoritesRepository.removeFavorite(event.adId);
      final favorites = await _favoritesRepository.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onCheckFavorite(
      CheckFavorite event, Emitter<FavoritesState> emit) async {
    try {
      final isFavorite =
          await _favoritesRepository.isFavorite(event.adId);
      emit(FavoriteChecked(isFavorite));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
