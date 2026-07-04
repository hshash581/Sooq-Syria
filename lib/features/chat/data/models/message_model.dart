import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel extends Equatable {
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

  MessageModel({
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

  factory MessageModel.fromJson(Map<String, dynamic> json, String id) {
    return MessageModel(
      id: id,
      chatId: json['chatId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderName: json['senderName'] as String? ?? '',
      senderImage: json['senderImage'] as String? ?? '',
      text: json['text'] as String? ?? '',
      type: json['type'] as String? ?? 'text',
      imageUrl: json['imageUrl'] as String?,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'senderImage': senderImage,
      'text': text,
      'type': type,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
    };
  }

  MessageModel copyWith({
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
    return MessageModel(
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

  @override
  List<Object?> get props => [id, chatId, text, createdAt];
}
