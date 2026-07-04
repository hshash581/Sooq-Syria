import 'package:equatable/equatable.dart';

import '../../../chat/domain/entities/chat_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatsInitial extends ChatState {
  const ChatsInitial();
}

class ChatsLoading extends ChatState {
  const ChatsLoading();
}

class ChatsLoaded extends ChatState {
  final List<ChatEntity> chats;

  const ChatsLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ChatsError extends ChatState {
  final String message;

  const ChatsError(this.message);

  @override
  List<Object?> get props => [message];
}
