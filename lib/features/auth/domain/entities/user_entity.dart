import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? profileImage;
  final String? bio;
  final String governorate;
  final String city;
  final String? address;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime lastSeen;
  final bool isActive;
  final bool isVerified;
  final int adsCount;
  final int salesCount;
  final int favoritesCount;
  final double rating;
  final String? fcmToken;
  final String role;

  UserEntity({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.profileImage,
    this.bio,
    this.governorate = '',
    this.city = '',
    this.address,
    this.latitude,
    this.longitude,
    DateTime? createdAt,
    DateTime? lastSeen,
    this.isActive = true,
    this.isVerified = false,
    this.adsCount = 0,
    this.salesCount = 0,
    this.favoritesCount = 0,
    this.rating = 0,
    this.fcmToken,
    this.role = 'user',
  })  : createdAt = createdAt ?? DateTime.now(),
        lastSeen = lastSeen ?? DateTime.now();

  UserEntity copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? profileImage,
    String? bio,
    String? governorate,
    String? city,
    String? address,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isActive,
    bool? isVerified,
    int? adsCount,
    int? salesCount,
    int? favoritesCount,
    double? rating,
    String? fcmToken,
    String? role,
  }) {
    return UserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      adsCount: adsCount ?? this.adsCount,
      salesCount: salesCount ?? this.salesCount,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      rating: rating ?? this.rating,
      fcmToken: fcmToken ?? this.fcmToken,
      role: role ?? this.role,
    );
  }

  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      id: model.id,
      fullName: model.fullName,
      phoneNumber: model.phoneNumber,
      email: model.email,
      profileImage: model.profileImage,
      bio: model.bio,
      governorate: model.governorate,
      city: model.city,
      address: model.address,
      latitude: model.latitude,
      longitude: model.longitude,
      createdAt: model.createdAt,
      lastSeen: model.lastSeen,
      isActive: model.isActive,
      isVerified: model.isVerified,
      adsCount: model.adsCount,
      salesCount: model.salesCount,
      favoritesCount: model.favoritesCount,
      rating: model.rating,
      fcmToken: model.fcmToken,
      role: model.role,
    );
  }

  UserModel toModel() {
    return UserModel(
      id: id,
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      profileImage: profileImage,
      bio: bio,
      governorate: governorate,
      city: city,
      address: address,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      lastSeen: lastSeen,
      isActive: isActive,
      isVerified: isVerified,
      adsCount: adsCount,
      salesCount: salesCount,
      favoritesCount: favoritesCount,
      rating: rating,
      fcmToken: fcmToken,
      role: role,
    );
  }

  @override
  List<Object?> get props => [id, phoneNumber];
}
