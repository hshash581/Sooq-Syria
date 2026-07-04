import 'package:equatable/equatable.dart';
import '../../data/models/banner_model.dart';

class BannerEntity extends Equatable {
  final String id;
  final String image;
  final String? title;
  final String? subtitle;
  final String? action;
  final String? actionValue;
  final int order;
  final bool isActive;

  const BannerEntity({
    required this.id,
    required this.image,
    this.title,
    this.subtitle,
    this.action,
    this.actionValue,
    this.order = 0,
    this.isActive = true,
  });

  BannerEntity copyWith({
    String? id,
    String? image,
    String? title,
    String? subtitle,
    String? action,
    String? actionValue,
    int? order,
    bool? isActive,
  }) {
    return BannerEntity(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      action: action ?? this.action,
      actionValue: actionValue ?? this.actionValue,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
    );
  }

  factory BannerEntity.fromModel(BannerModel model) {
    return BannerEntity(
      id: model.id,
      image: model.image,
      title: model.title,
      subtitle: model.subtitle,
      action: model.action,
      actionValue: model.actionValue,
      order: model.order,
      isActive: model.isActive,
    );
  }

  BannerModel toModel() {
    return BannerModel(
      id: id,
      image: image,
      title: title,
      subtitle: subtitle,
      action: action,
      actionValue: actionValue,
      order: order,
      isActive: isActive,
    );
  }

  @override
  List<Object?> get props => [id, image];
}
