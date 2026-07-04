import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../ads/domain/entities/ad_entity.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/domain/repositories/categories_repository.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final CategoriesRepository _categoriesRepository;

  HomeBloc({
    required HomeRepository homeRepository,
    required CategoriesRepository categoriesRepository,
  })  : _homeRepository = homeRepository,
        _categoriesRepository = categoriesRepository,
        super(const HomeInitial()) {
    on<LoadHome>(_onLoadHome);
    on<RefreshHome>(_onRefreshHome);
  }

  Future<void> _onLoadHome(
      LoadHome event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    try {
      final results = await Future.wait([
        _homeRepository.getBanners(),
        _categoriesRepository.getCategories(),
        _homeRepository.getLatestAds(),
        _homeRepository.getFeaturedAds(),
        _homeRepository.getMostViewedAds(),
      ]);

      emit(HomeLoaded(
        banners: results[0] as List<BannerEntity>,
        categories: results[1] as List<CategoryEntity>,
        latestAds: results[2] as List<AdEntity>,
        featuredAds: results[3] as List<AdEntity>,
        mostViewedAds: results[4] as List<AdEntity>,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshHome(
      RefreshHome event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    try {
      final results = await Future.wait([
        _homeRepository.getBanners(),
        _categoriesRepository.getCategories(),
        _homeRepository.getLatestAds(),
        _homeRepository.getFeaturedAds(),
        _homeRepository.getMostViewedAds(),
      ]);

      emit(HomeLoaded(
        banners: results[0] as List<BannerEntity>,
        categories: results[1] as List<CategoryEntity>,
        latestAds: results[2] as List<AdEntity>,
        featuredAds: results[3] as List<AdEntity>,
        mostViewedAds: results[4] as List<AdEntity>,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
