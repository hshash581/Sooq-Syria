import 'package:equatable/equatable.dart';
import '../../data/models/chat_model.dart';

class ChatEntity extends Equatable {
  final String id;
  final String adId;
  final String adTitle;
  final String adImage;
  final String buyerId;
  final String sellerId;
  final String buyerName;
  final String sellerName;
  final String? buyerImage;
  final String? sellerImage;
  final String lastMessage;
  final String lastMessageType;
  final DateTime lastMessageTime;
  final bool isReadByBuyer;
  final bool isReadBySeller;
  final String lastSenderId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatEntity({
    required this.id,
    required this.adId,
    this.adTitle = '',
    this.adImage = '',
    required this.buyerId,
    required this.sellerId,
    this.buyerName = '',
    this.sellerName = '',
    this.buyerImage,
    this.sellerImage,
    this.lastMessage = '',
    this.lastMessageType = 'text',
    DateTime? lastMessageTime,
    this.isReadByBuyer = true,
    this.isReadBySeller = true,
    this.lastSenderId = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : lastMessageTime = lastMessageTime ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  ChatEntity copyWith({
    String? id,
    String? adId,
    String? adTitle,
    String? adImage,
    String? buyerId,
    String? sellerId,
    String? buyerName,
    String? sellerName,
    String? buyerImage,
    String? sellerImage,
    String? lastMessage,
    String? lastMessageType,
    DateTime? lastMessageTime,
    bool? isReadByBuyer,
    bool? isReadBySeller,
    String? lastSenderId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatEntity(
      id: id ?? this.id,
      adId: adId ?? this.adId,
      adTitle: adTitle ?? this.adTitle,
      adImage: adImage ?? this.adImage,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      buyerName: buyerName ?? this.buyerName,
      sellerName: sellerName ?? this.sellerName,
      buyerImage: buyerImage ?? this.buyerImage,
      sellerImage: sellerImage ?? this.sellerImage,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isReadByBuyer: isReadByBuyer ?? this.isReadByBuyer,
      isReadBySeller: isReadBySeller ?? this.isReadBySeller,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ChatEntity.fromModel(ChatModel model) {
    return ChatEntity(
      id: model.id,
      adId: model.adId,
      adTitle: model.adTitle,
      adImage: model.adImage,
      buyerId: model.buyerId,
      sellerId: model.sellerId,
      buyerName: model.buyerName,
      sellerName: model.sellerName,
      buyerImage: model.buyerImage,
      sellerImage: model.sellerImage,
      lastMessage: model.lastMessage,
      lastMessageType: model.lastMessageType,
      lastMessageTime: model.lastMessageTime,
      isReadByBuyer: model.isReadByBuyer,
      isReadBySeller: model.isReadBySeller,
      lastSenderId: model.lastSenderId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  ChatModel toModel() {
    return ChatModel(
      id: id,
      adId: adId,
      adTitle: adTitle,
      adImage: adImage,
      buyerId: buyerId,
      sellerId: sellerId,
      buyerName: buyerName,
      sellerName: sellerName,
      buyerImage: buyerImage ?? '',
      sellerImage: sellerImage ?? '',
      lastMessage: lastMessage,
      lastMessageType: lastMessageType,
      lastMessageTime: lastMessageTime,
      isReadByBuyer: isReadByBuyer,
      isReadBySeller: isReadBySeller,
      lastSenderId: lastSenderId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  bool isUnread(String currentUserId) {
    if (currentUserId == buyerId) return !isReadByBuyer;
    return !isReadBySeller;
  }

  @override
  List<Object?> get props => [id, lastMessage, lastMessageTime];
}
