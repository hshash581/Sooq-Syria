import 'dart:io';

import '../../domain/entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class CreateAd {
  final AdsRepository repository;
  CreateAd(this.repository);

  Future<AdEntity> call(AdEntity ad, List<File> images) {
    return repository.createAd(ad, images);
  }
}
