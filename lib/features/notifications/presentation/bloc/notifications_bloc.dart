import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../domain/repositories/notifications_repository.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc
    extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository _notificationsRepository;

  NotificationsBloc(
      {required NotificationsRepository notificationsRepository})
      : _notificationsRepository = notificationsRepository,
        super(const NotificationsInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<DeleteNotification>(_onDeleteNotification);
  }

  Future<void> _onLoadNotifications(
      LoadNotifications event, Emitter<NotificationsState> emit) async {
    emit(const NotificationsLoading());
    try {
      final notifications =
          await _notificationsRepository.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> _onMarkAsRead(
      MarkAsRead event, Emitter<NotificationsState> emit) async {
    try {
      await _notificationsRepository.markAsRead(event.notificationId);
      final notifications =
          await _notificationsRepository.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> _onDeleteNotification(
      DeleteNotification event,
      Emitter<NotificationsState> emit) async {
    try {
      await _notificationsRepository.deleteNotification(
          event.notificationId);
      final notifications =
          await _notificationsRepository.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }
}
