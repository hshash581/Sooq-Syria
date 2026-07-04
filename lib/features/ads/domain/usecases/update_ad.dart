import 'dart:io';

import '../../domain/entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class UpdateAd {
  final AdsRepository repository;
  UpdateAd(this.repository);

  Future<AdEntity> call(AdEntity ad,
      {List<File>? newImages, List<String>? deletedImages}) {
    return repository.updateAd(ad,
        newImages: newImages, deletedImages: deletedImages);
  }
}
