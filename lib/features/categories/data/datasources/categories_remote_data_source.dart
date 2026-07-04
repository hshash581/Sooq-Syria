import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/firebase_config.dart';
import '../../../../core/services/firebase_service.dart';
import '../../data/models/category_model.dart';

class CategoriesRemoteDataSource {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.categoriesCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get categories: ${e.message}');
    }
  }

  Stream<List<CategoryModel>> streamCategories() {
    return _firebaseService.firestore
        .collection(FirebaseConfig.categoriesCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  Future<CategoryModel> getCategory(String categoryId) async {
    try {
      final doc = await _firebaseService.firestore
          .collection(FirebaseConfig.categoriesCollection)
          .doc(categoryId)
          .get();

      if (!doc.exists) throw Exception('Category not found');
      return CategoryModel.fromJson(doc.data()!, doc.id);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get category: ${e.message}');
    }
  }
}
