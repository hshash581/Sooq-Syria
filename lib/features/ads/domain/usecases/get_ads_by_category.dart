import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class GetAdsByCategory {
  final AdsRepository repository;
  GetAdsByCategory(this.repository);

  Future<List<AdEntity>> call(String categoryId,
      {DocumentSnapshot? lastDoc}) {
    return repository.getAdsByCategory(categoryId, lastDoc: lastDoc);
  }
}
