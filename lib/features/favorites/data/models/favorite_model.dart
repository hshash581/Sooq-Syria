import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel extends Equatable {
  final String id;
  final String userId;
  final String adId;
  final DateTime createdAt;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.adId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory FavoriteModel.fromJson(Map<String, dynamic> json, String id) {
    return FavoriteModel(
      id: id,
      userId: json['userId'] as String? ?? '',
      adId: json['adId'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'adId': adId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  FavoriteModel copyWith({
    String? id,
    String? userId,
    String? adId,
    DateTime? createdAt,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      adId: adId ?? this.adId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, adId];
}
