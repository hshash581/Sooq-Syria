import 'package:equatable/equatable.dart';
import '../../data/models/notification_model.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type;
  final String? adId;
  final String? chatId;
  final bool isRead;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.adId,
    this.chatId,
    this.isRead = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? type,
    String? adId,
    String? chatId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      adId: adId ?? this.adId,
      chatId: chatId ?? this.chatId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory NotificationEntity.fromModel(NotificationModel model) {
    return NotificationEntity(
      id: model.id,
      userId: model.userId,
      title: model.title,
      body: model.body,
      type: model.type,
      adId: model.adId,
      chatId: model.chatId,
      isRead: model.isRead,
      createdAt: model.createdAt,
    );
  }

  NotificationModel toModel() {
    return NotificationModel(
      id: id,
      userId: userId,
      title: title,
      body: body,
      type: type,
      adId: adId,
      chatId: chatId,
      isRead: isRead,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, isRead];
}
