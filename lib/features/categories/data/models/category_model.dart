import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String? icon;
  final String? image;
  final String? color;
  final int order;
  final bool isActive;
  final int adsCount;

  const CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.image,
    this.color,
    this.order = 0,
    this.isActive = true,
    this.adsCount = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json, String id) {
    return CategoryModel(
      id: id,
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String?,
      image: json['image'] as String?,
      color: json['color'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      adsCount: (json['adsCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'image': image,
      'color': color,
      'order': order,
      'isActive': isActive,
      'adsCount': adsCount,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
    String? image,
    String? color,
    int? order,
    bool? isActive,
    int? adsCount,
  }) {
    return CategoryModel(
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

  @override
  List<Object?> get props => [id, name];
}
