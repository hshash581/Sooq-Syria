import 'package:equatable/equatable.dart';

import '../../../ads/domain/entities/ad_entity.dart';

abstract class CreateAdState extends Equatable {
  const CreateAdState();

  @override
  List<Object?> get props => [];
}

class CreateAdInitial extends CreateAdState {
  const CreateAdInitial();
}

class CreateAdLoading extends CreateAdState {
  const CreateAdLoading();
}

class CreateAdSuccess extends CreateAdState {
  final AdEntity ad;

  const CreateAdSuccess(this.ad);

  @override
  List<Object?> get props => [ad];
}

class CreateAdError extends CreateAdState {
  final String message;

  const CreateAdError(this.message);

  @override
  List<Object?> get props => [message];
}
