import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../ads/domain/entities/ad_entity.dart';
import '../repositories/search_repository.dart';

class SearchAds {
  final SearchRepository repository;
  SearchAds(this.repository);

  Future<List<AdEntity>> call(String query, {DocumentSnapshot? lastDoc}) {
    return repository.searchAds(query, lastDoc: lastDoc);
  }
}
