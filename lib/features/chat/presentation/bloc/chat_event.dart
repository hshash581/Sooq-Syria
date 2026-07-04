import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChats extends ChatEvent {
  const LoadChats();
}

class CreateChat extends ChatEvent {
  final String adId;
  final String sellerId;

  const CreateChat(this.adId, this.sellerId);

  @override
  List<Object?> get props => [adId, sellerId];
}

class MarkAsRead extends ChatEvent {
  final String chatId;

  const MarkAsRead(this.chatId);

  @override
  List<Object?> get props => [chatId];
}
