import 'package:equatable/equatable.dart';
import '../../data/models/ad_model.dart';

class AdEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String categoryId;
  final String categoryName;
  final String governorate;
  final String city;
  final String? address;
  final double price;
  final String currency;
  final bool isNegotiable;
  final bool isNew;
  final String contactNumber;
  final bool showNumber;
  final List<String> images;
  final double? latitude;
  final double? longitude;
  final String status;
  final bool isFeatured;
  final int viewsCount;
  final int likesCount;
  final int chatsCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? expiresAt;
  final String? rejectReason;

  AdEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.governorate,
    required this.city,
    this.address,
    required this.price,
    this.currency = 'SYP',
    this.isNegotiable = false,
    this.isNew = true,
    required this.contactNumber,
    this.showNumber = true,
    required this.images,
    this.latitude,
    this.longitude,
    this.status = 'pending',
    this.isFeatured = false,
    this.viewsCount = 0,
    this.likesCount = 0,
    this.chatsCount = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.expiresAt,
    this.rejectReason,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  AdEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? categoryId,
    String? categoryName,
    String? governorate,
    String? city,
    String? address,
    double? price,
    String? currency,
    bool? isNegotiable,
    bool? isNew,
    String? contactNumber,
    bool? showNumber,
    List<String>? images,
    double? latitude,
    double? longitude,
    String? status,
    bool? isFeatured,
    int? viewsCount,
    int? likesCount,
    int? chatsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expiresAt,
    String? rejectReason,
  }) {
    return AdEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      address: address ?? this.address,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      isNew: isNew ?? this.isNew,
      contactNumber: contactNumber ?? this.contactNumber,
      showNumber: showNumber ?? this.showNumber,
      images: images ?? this.images,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      viewsCount: viewsCount ?? this.viewsCount,
      likesCount: likesCount ?? this.likesCount,
      chatsCount: chatsCount ?? this.chatsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rejectReason: rejectReason ?? this.rejectReason,
    );
  }

  factory AdEntity.fromModel(AdModel model) {
    return AdEntity(
      id: model.id,
      userId: model.userId,
      title: model.title,
      description: model.description,
      categoryId: model.categoryId,
      categoryName: model.categoryName,
      governorate: model.governorate,
      city: model.city,
      address: model.address,
      price: model.price,
      currency: model.currency,
      isNegotiable: model.isNegotiable,
      isNew: model.isNew,
      contactNumber: model.contactNumber,
      showNumber: model.showNumber,
      images: List<String>.from(model.images),
      latitude: model.latitude,
      longitude: model.longitude,
      status: model.status,
      isFeatured: model.isFeatured,
      viewsCount: model.viewsCount,
      likesCount: model.likesCount,
      chatsCount: model.chatsCount,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      expiresAt: model.expiresAt,
      rejectReason: model.rejectReason,
    );
  }

  AdModel toModel() {
    return AdModel(
      id: id,
      userId: userId,
      title: title,
      description: description,
      categoryId: categoryId,
      categoryName: categoryName,
      governorate: governorate,
      city: city,
      address: address,
      price: price,
      currency: currency,
      isNegotiable: isNegotiable,
      isNew: isNew,
      contactNumber: contactNumber,
      showNumber: showNumber,
      images: List<String>.from(images),
      latitude: latitude,
      longitude: longitude,
      status: status,
      isFeatured: isFeatured,
      viewsCount: viewsCount,
      likesCount: likesCount,
      chatsCount: chatsCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      expiresAt: expiresAt,
      rejectReason: rejectReason,
    );
  }

  @override
  List<Object?> get props => [id, title, price];
}
