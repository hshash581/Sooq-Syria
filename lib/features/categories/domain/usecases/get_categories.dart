import '../../domain/entities/category_entity.dart';
import '../repositories/categories_repository.dart';

class GetCategories {
  final CategoriesRepository repository;
  GetCategories(this.repository);

  Future<List<CategoryEntity>> call() {
    return repository.getCategories();
  }
}
