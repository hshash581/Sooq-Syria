import 'package:equatable/equatable.dart';

import '../../../ads/domain/entities/ad_entity.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../domain/entities/banner_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<BannerEntity> banners;
  final List<CategoryEntity> categories;
  final List<AdEntity> latestAds;
  final List<AdEntity> featuredAds;
  final List<AdEntity> mostViewedAds;

  const HomeLoaded({
    required this.banners,
    required this.categories,
    required this.latestAds,
    required this.featuredAds,
    required this.mostViewedAds,
  });

  @override
  List<Object?> get props =>
      [banners, categories, latestAds, featuredAds, mostViewedAds];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
