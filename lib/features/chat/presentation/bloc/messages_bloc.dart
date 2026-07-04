import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/chat_repository.dart';
import 'messages_event.dart';
import 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final ChatRepository _chatRepository;
  DocumentSnapshot? _lastDoc;
  String? _currentChatId;

  MessagesBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(const MessagesInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<MarkMessageRead>(_onMarkMessageRead);
    on<LoadMoreMessages>(_onLoadMoreMessages);
  }

  Future<void> _onLoadMessages(
      LoadMessages event, Emitter<MessagesState> emit) async {
    emit(const MessagesLoading());
    _currentChatId = event.chatId;
    _lastDoc = null;
    try {
      final messages =
          await _chatRepository.getMessages(event.chatId);
      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<MessagesState> emit) async {
    if (state is! MessagesLoaded) return;
    try {
      await _chatRepository.sendMessage(
        event.chatId,
        event.text,
        image: event.image,
      );
      final messages =
          await _chatRepository.getMessages(event.chatId);
      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }

  Future<void> _onMarkMessageRead(
      MarkMessageRead event, Emitter<MessagesState> emit) async {
    try {
      await _chatRepository.markAsRead(event.messageId);
    } catch (_) {}
  }

  Future<void> _onLoadMoreMessages(
      LoadMoreMessages event, Emitter<MessagesState> emit) async {
    if (_currentChatId == null) return;
    if (state is! MessagesLoaded) return;
    try {
      final moreMessages =
          await _chatRepository.getMessages(_currentChatId!);
      final currentState = state as MessagesLoaded;
      final allMessages = [...currentState.messages, ...moreMessages];
      emit(MessagesLoaded(allMessages));
    } catch (_) {}
  }
}
