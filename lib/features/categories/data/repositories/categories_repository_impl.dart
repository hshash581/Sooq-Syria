import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/domain/repositories/categories_repository.dart';
import '../datasources/categories_remote_data_source.dart';
import '../models/category_model.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;

  CategoriesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final models = await remoteDataSource.getCategories();
      return models.map((model) => CategoryEntity.fromModel(model)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CategoryEntity> getCategoryById(String id) async {
    try {
      final model = await remoteDataSource.getCategory(id);
      return CategoryEntity.fromModel(model);
    } catch (e) {
      rethrow;
    }
  }
}
