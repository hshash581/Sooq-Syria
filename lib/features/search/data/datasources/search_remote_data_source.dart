import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/firebase_config.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../ads/data/models/ad_model.dart';

class SearchFilters {
  final String? categoryId;
  final String? governorate;
  final String? city;
  final double? minPrice;
  final double? maxPrice;
  final bool? isNew;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? sortBy;

  const SearchFilters({
    this.categoryId,
    this.governorate,
    this.city,
    this.minPrice,
    this.maxPrice,
    this.isNew,
    this.dateFrom,
    this.dateTo,
    this.sortBy,
  });
}

class SearchRemoteDataSource {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<AdModel>> searchAds(
    String query, {
    SearchFilters? filters,
    DocumentSnapshot? lastDoc,
    int limit = 20,
  }) async {
    try {
      Query firestoreQuery = _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .where('status', isEqualTo: 'approved');

      if (filters != null) {
        if (filters.categoryId != null) {
          firestoreQuery =
              firestoreQuery.where('categoryId', isEqualTo: filters.categoryId);
        }
        if (filters.governorate != null) {
          firestoreQuery =
              firestoreQuery.where('governorate', isEqualTo: filters.governorate);
        }
        if (filters.city != null) {
          firestoreQuery =
              firestoreQuery.where('city', isEqualTo: filters.city);
        }
        if (filters.isNew != null) {
          firestoreQuery =
              firestoreQuery.where('isNew', isEqualTo: filters.isNew);
        }
      }

      if (filters?.sortBy == 'price_asc') {
        firestoreQuery = firestoreQuery.orderBy('price', descending: false);
      } else if (filters?.sortBy == 'price_desc') {
        firestoreQuery = firestoreQuery.orderBy('price', descending: true);
      } else if (filters?.sortBy == 'views') {
        firestoreQuery = firestoreQuery.orderBy('viewsCount', descending: true);
      } else {
        firestoreQuery = firestoreQuery.orderBy('createdAt', descending: true);
      }

      if (lastDoc != null) {
        firestoreQuery = firestoreQuery.startAfterDocument(lastDoc);
      }

      firestoreQuery = firestoreQuery.limit(limit);

      final snapshot = await firestoreQuery.get();
      var ads = snapshot.docs
          .map((doc) => AdModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      if (query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        ads = ads.where((ad) {
          return ad.title.toLowerCase().contains(lowerQuery) ||
              ad.description.toLowerCase().contains(lowerQuery);
        }).toList();
      }

      if (filters != null) {
        if (filters.minPrice != null) {
          ads = ads.where((ad) => ad.price >= filters.minPrice!).toList();
        }
        if (filters.maxPrice != null) {
          ads = ads.where((ad) => ad.price <= filters.maxPrice!).toList();
        }
        if (filters.dateFrom != null) {
          ads = ads
              .where((ad) => ad.createdAt.isAfter(filters.dateFrom!))
              .toList();
        }
        if (filters.dateTo != null) {
          ads = ads
              .where((ad) => ad.createdAt.isBefore(filters.dateTo!))
              .toList();
        }
      }

      return ads;
    } on FirebaseException catch (e) {
      throw Exception('Failed to search ads: ${e.message}');
    }
  }
}
