import 'package:equatable/equatable.dart';
import '../../data/models/message_model.dart';

class MessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String senderImage;
  final String text;
  final String type;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isRead;

  MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.senderName = '',
    this.senderImage = '',
    this.text = '',
    this.type = 'text',
    this.imageUrl,
    DateTime? createdAt,
    this.isRead = false,
  }) : createdAt = createdAt ?? DateTime.now();

  MessageEntity copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? senderName,
    String? senderImage,
    String? text,
    String? type,
    String? imageUrl,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderImage: senderImage ?? this.senderImage,
      text: text ?? this.text,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  factory MessageEntity.fromModel(MessageModel model) {
    return MessageEntity(
      id: model.id,
      chatId: model.chatId,
      senderId: model.senderId,
      senderName: model.senderName,
      senderImage: model.senderImage ?? '',
      text: model.text,
      type: model.type,
      imageUrl: model.imageUrl,
      createdAt: model.createdAt,
      isRead: model.isRead,
    );
  }

  MessageModel toModel() {
    return MessageModel(
      id: id,
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      senderImage: senderImage.isNotEmpty ? senderImage : '',
      text: text,
      type: type,
      imageUrl: imageUrl,
      createdAt: createdAt,
      isRead: isRead,
    );
  }

  @override
  List<Object?> get props => [id, chatId, text, createdAt];
}
