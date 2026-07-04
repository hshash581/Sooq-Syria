import 'package:equatable/equatable.dart';

import '../../../ads/domain/entities/ad_entity.dart';

abstract class AdsState extends Equatable {
  const AdsState();

  @override
  List<Object?> get props => [];
}

class AdsInitial extends AdsState {
  const AdsInitial();
}

class AdsLoading extends AdsState {
  const AdsLoading();
}

class AdsLoaded extends AdsState {
  final List<AdEntity> ads;
  final bool hasMore;

  const AdsLoaded({required this.ads, this.hasMore = true});

  @override
  List<Object?> get props => [ads, hasMore];
}

class AdsError extends AdsState {
  final String message;

  const AdsError(this.message);

  @override
  List<Object?> get props => [message];
}
