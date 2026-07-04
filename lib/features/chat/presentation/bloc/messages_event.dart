import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessages extends MessagesEvent {
  final String chatId;

  const LoadMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendMessage extends MessagesEvent {
  final String chatId;
  final String text;
  final File? image;

  const SendMessage(this.chatId, this.text, {this.image});

  @override
  List<Object?> get props => [chatId, text, image];
}

class MarkMessageRead extends MessagesEvent {
  final String messageId;

  const MarkMessageRead(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class LoadMoreMessages extends MessagesEvent {
  const LoadMoreMessages();
}
