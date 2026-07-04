import 'package:equatable/equatable.dart';

class BannerModel extends Equatable {
  final String id;
  final String image;
  final String? title;
  final String? subtitle;
  final String? action;
  final String? actionValue;
  final int order;
  final bool isActive;

  const BannerModel({
    required this.id,
    required this.image,
    this.title,
    this.subtitle,
    this.action,
    this.actionValue,
    this.order = 0,
    this.isActive = true,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json, String id) {
    return BannerModel(
      id: id,
      image: json['image'] as String? ?? '',
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      action: json['action'] as String?,
      actionValue: json['actionValue'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'subtitle': subtitle,
      'action': action,
      'actionValue': actionValue,
      'order': order,
      'isActive': isActive,
    };
  }

  BannerModel copyWith({
    String? id,
    String? image,
    String? title,
    String? subtitle,
    String? action,
    String? actionValue,
    int? order,
    bool? isActive,
  }) {
    return BannerModel(
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

  @override
  List<Object?> get props => [id, image];
}
