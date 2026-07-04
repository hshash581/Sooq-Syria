import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel extends Equatable {
  final String id;
  final String adId;
  final String adTitle;
  final String adImage;
  final String buyerId;
  final String sellerId;
  final String buyerName;
  final String sellerName;
  final String buyerImage;
  final String sellerImage;
  final String lastMessage;
  final String lastMessageType;
  final DateTime lastMessageTime;
  final bool isReadByBuyer;
  final bool isReadBySeller;
  final String lastSenderId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatModel({
    required this.id,
    required this.adId,
    this.adTitle = '',
    this.adImage = '',
    required this.buyerId,
    required this.sellerId,
    this.buyerName = '',
    this.sellerName = '',
    this.buyerImage = '',
    this.sellerImage = '',
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

  factory ChatModel.fromJson(Map<String, dynamic> json, String id) {
    return ChatModel(
      id: id,
      adId: json['adId'] as String? ?? '',
      adTitle: json['adTitle'] as String? ?? '',
      adImage: json['adImage'] as String? ?? '',
      buyerId: json['buyerId'] as String? ?? '',
      sellerId: json['sellerId'] as String? ?? '',
      buyerName: json['buyerName'] as String? ?? '',
      sellerName: json['sellerName'] as String? ?? '',
      buyerImage: json['buyerImage'] as String? ?? '',
      sellerImage: json['sellerImage'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageType: json['lastMessageType'] as String? ?? 'text',
      lastMessageTime: (json['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isReadByBuyer: json['isReadByBuyer'] as bool? ?? true,
      isReadBySeller: json['isReadBySeller'] as bool? ?? true,
      lastSenderId: json['lastSenderId'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adId': adId,
      'adTitle': adTitle,
      'adImage': adImage,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'buyerName': buyerName,
      'sellerName': sellerName,
      'buyerImage': buyerImage,
      'sellerImage': sellerImage,
      'lastMessage': lastMessage,
      'lastMessageType': lastMessageType,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'isReadByBuyer': isReadByBuyer,
      'isReadBySeller': isReadBySeller,
      'lastSenderId': lastSenderId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ChatModel copyWith({
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
    return ChatModel(
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

  bool isUnread(String currentUserId) {
    if (currentUserId == buyerId) return !isReadByBuyer;
    return !isReadBySeller;
  }

  @override
  List<Object?> get props => [id, lastMessage, lastMessageTime];
}
