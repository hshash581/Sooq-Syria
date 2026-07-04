import '../../../categories/domain/entities/category_entity.dart';
import '../repositories/home_repository.dart';

class GetCategories {
  final HomeRepository repository;
  GetCategories(this.repository);

  Future<List<CategoryEntity>> call() {
    return repository.getCategories();
  }
}
