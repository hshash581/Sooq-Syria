import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../ads/domain/entities/ad_entity.dart';
import '../repositories/admin_repository.dart';

class GetPendingAds {
  final AdminRepository repository;
  GetPendingAds(this.repository);

  Future<List<AdEntity>> call({DocumentSnapshot? lastDoc}) {
    return repository.getPendingAds(lastDoc: lastDoc);
  }
}
