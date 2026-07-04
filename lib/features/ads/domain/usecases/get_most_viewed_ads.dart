import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class GetMostViewedAds {
  final AdsRepository repository;
  GetMostViewedAds(this.repository);

  Future<List<AdEntity>> call({DocumentSnapshot? lastDoc}) {
    return repository.getMostViewedAds(lastDoc: lastDoc);
  }
}
