import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(const ChatsInitial()) {
    on<LoadChats>(_onLoadChats);
    on<CreateChat>(_onCreateChat);
    on<MarkAsRead>(_onMarkAsRead);
  }

  Future<void> _onLoadChats(
      LoadChats event, Emitter<ChatState> emit) async {
    emit(const ChatsLoading());
    try {
      final chats = await _chatRepository.getChats();
      emit(ChatsLoaded(chats));
    } catch (e) {
      emit(ChatsError(e.toString()));
    }
  }

  Future<void> _onCreateChat(
      CreateChat event, Emitter<ChatState> emit) async {
    emit(const ChatsLoading());
    try {
      await _chatRepository.createChat(event.adId, event.sellerId);
      final chats = await _chatRepository.getChats();
      emit(ChatsLoaded(chats));
    } catch (e) {
      emit(ChatsError(e.toString()));
    }
  }

  Future<void> _onMarkAsRead(
      MarkAsRead event, Emitter<ChatState> emit) async {
    try {
      await _chatRepository.markAsRead(event.chatId);
      final chats = await _chatRepository.getChats();
      emit(ChatsLoaded(chats));
    } catch (e) {
      emit(ChatsError(e.toString()));
    }
  }
}
