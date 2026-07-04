import 'package:equatable/equatable.dart';
import '../../data/models/favorite_model.dart';

class FavoriteEntity extends Equatable {
  final String id;
  final String userId;
  final String adId;
  final DateTime createdAt;

  FavoriteEntity({
    required this.id,
    required this.userId,
    required this.adId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  FavoriteEntity copyWith({
    String? id,
    String? userId,
    String? adId,
    DateTime? createdAt,
  }) {
    return FavoriteEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      adId: adId ?? this.adId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory FavoriteEntity.fromModel(FavoriteModel model) {
    return FavoriteEntity(
      id: model.id,
      userId: model.userId,
      adId: model.adId,
      createdAt: model.createdAt,
    );
  }

  FavoriteModel toModel() {
    return FavoriteModel(
      id: id,
      userId: userId,
      adId: adId,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, adId];
}
