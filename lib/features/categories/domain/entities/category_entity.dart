import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String? icon;
  final String? image;
  final String? color;
  final int order;
  final bool isActive;
  final int adsCount;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.icon,
    this.image,
    this.color,
    this.order = 0,
    this.isActive = true,
    this.adsCount = 0,
  });

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? icon,
    String? image,
    String? color,
    int? order,
    bool? isActive,
    int? adsCount,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      color: color ?? this.color,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      adsCount: adsCount ?? this.adsCount,
    );
  }

  factory CategoryEntity.fromModel(CategoryModel model) {
    return CategoryEntity(
      id: model.id,
      name: model.name,
      icon: model.icon,
      image: model.image,
      color: model.color,
      order: model.order,
      isActive: model.isActive,
      adsCount: model.adsCount,
    );
  }

  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      name: name,
      icon: icon,
      image: image,
      color: color,
      order: order,
      isActive: isActive,
      adsCount: adsCount,
    );
  }

  @override
  List<Object?> get props => [id, name];
}
