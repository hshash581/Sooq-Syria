import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../ads/domain/entities/ad_entity.dart';

abstract class CreateAdEvent extends Equatable {
  const CreateAdEvent();

  @override
  List<Object?> get props => [];
}

class CreateAd extends CreateAdEvent {
  final AdEntity ad;
  final List<File> images;

  const CreateAd(this.ad, this.images);

  @override
  List<Object?> get props => [ad, images];
}

class UpdateAd extends CreateAdEvent {
  final AdEntity ad;
  final List<File>? newImages;
  final List<String>? deletedImages;

  const UpdateAd(this.ad, {this.newImages, this.deletedImages});

  @override
  List<Object?> get props => [ad, newImages, deletedImages];
}

class ResetCreateAd extends CreateAdEvent {
  const ResetCreateAd();
}
