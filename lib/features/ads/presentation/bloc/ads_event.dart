import 'package:equatable/equatable.dart';

abstract class AdsEvent extends Equatable {
  const AdsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAds extends AdsEvent {
  const LoadAds();
}

class LoadAdsByUser extends AdsEvent {
  final String userId;

  const LoadAdsByUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadAdsByCategory extends AdsEvent {
  final String categoryId;

  const LoadAdsByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class LoadLatestAds extends AdsEvent {
  const LoadLatestAds();
}

class LoadFeaturedAds extends AdsEvent {
  const LoadFeaturedAds();
}

class LoadMostViewedAds extends AdsEvent {
  const LoadMostViewedAds();
}

class LoadMoreAds extends AdsEvent {
  const LoadMoreAds();
}

class RefreshAds extends AdsEvent {
  const RefreshAds();
}

class DeleteAd extends AdsEvent {
  final String adId;

  const DeleteAd(this.adId);

  @override
  List<Object?> get props => [adId];
}

class ToggleAdStatus extends AdsEvent {
  final String adId;

  const ToggleAdStatus(this.adId);

  @override
  List<Object?> get props => [adId];
}

class RenewAd extends AdsEvent {
  final String adId;

  const RenewAd(this.adId);

  @override
  List<Object?> get props => [adId];
}
