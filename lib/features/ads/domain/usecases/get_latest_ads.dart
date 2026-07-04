import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class GetLatestAds {
  final AdsRepository repository;
  GetLatestAds(this.repository);

  Future<List<AdEntity>> call({DocumentSnapshot? lastDoc}) {
    return repository.getLatestAds(lastDoc: lastDoc);
  }
}
