import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdModel extends Equatable {
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

  AdModel({
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

  factory AdModel.fromJson(Map<String, dynamic> json, String id) {
    return AdModel(
      id: id,
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      governorate: json['governorate'] as String? ?? '',
      city: json['city'] as String? ?? '',
      address: json['address'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'SYP',
      isNegotiable: json['isNegotiable'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? true,
      contactNumber: json['contactNumber'] as String? ?? '',
      showNumber: json['showNumber'] as bool? ?? true,
      images: List<String>.from(json['images'] as List<dynamic>? ?? []),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'pending',
      isFeatured: json['isFeatured'] as bool? ?? false,
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      chatsCount: (json['chatsCount'] as num?)?.toInt() ?? 0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (json['expiresAt'] as Timestamp?)?.toDate(),
      rejectReason: json['rejectReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'governorate': governorate,
      'city': city,
      'address': address,
      'price': price,
      'currency': currency,
      'isNegotiable': isNegotiable,
      'isNew': isNew,
      'contactNumber': contactNumber,
      'showNumber': showNumber,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'isFeatured': isFeatured,
      'viewsCount': viewsCount,
      'likesCount': likesCount,
      'chatsCount': chatsCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'rejectReason': rejectReason,
    };
  }

  AdModel copyWith({
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
    return AdModel(
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

  @override
  List<Object?> get props => [id, title, price];
}
