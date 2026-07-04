import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../ads/domain/entities/ad_entity.dart';
import '../repositories/home_repository.dart';

class GetLatestAds {
  final HomeRepository repository;
  GetLatestAds(this.repository);

  Future<List<AdEntity>> call({DocumentSnapshot? lastDoc}) {
    return repository.getLatestAds(lastDoc: lastDoc);
  }
}
