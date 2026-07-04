import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../domain/repositories/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsBloc({required SettingsRepository settingsRepository})
      : _settingsRepository = settingsRepository,
        super(const SettingsLoaded(
          themeMode: ThemeMode.light,
          language: 'ar',
          notificationsEnabled: true,
        )) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleDarkMode>(_onToggleDarkMode);
    on<ToggleNotifications>(_onToggleNotifications);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onLoadSettings(
      LoadSettings event, Emitter<SettingsState> emit) async {
    try {
      final themeModeStr = await _settingsRepository.getThemeMode();
      final language = await _settingsRepository.getLanguage();

      final themeMode = themeModeStr == 'dark'
          ? ThemeMode.dark
          : ThemeMode.light;

      emit(SettingsLoaded(
        themeMode: themeMode,
        language: language,
        notificationsEnabled: true,
      ));
    } catch (_) {
      emit(const SettingsLoaded(
        themeMode: ThemeMode.light,
        language: 'ar',
        notificationsEnabled: true,
      ));
    }
  }

  Future<void> _onToggleDarkMode(
      ToggleDarkMode event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final current = state as SettingsLoaded;
      final newMode = current.themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
      await _settingsRepository
          .setThemeMode(newMode == ThemeMode.dark ? 'dark' : 'light');
      emit(current.copyWith(themeMode: newMode));
    }
  }

  Future<void> _onToggleNotifications(
      ToggleNotifications event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final current = state as SettingsLoaded;
      emit(SettingsLoaded(
        themeMode: current.themeMode,
        language: current.language,
        notificationsEnabled: !current.notificationsEnabled,
      ));
    }
  }

  Future<void> _onChangeLanguage(
      ChangeLanguage event, Emitter<SettingsState> emit) async {
    await _settingsRepository.setLanguage(event.language);
    if (state is SettingsLoaded) {
      final current = state as SettingsLoaded;
      emit(SettingsLoaded(
        themeMode: current.themeMode,
        language: event.language,
        notificationsEnabled: current.notificationsEnabled,
      ));
    }
  }
}

extension _SettingsLoadedExtension on SettingsLoaded {
  SettingsLoaded copyWith({
    ThemeMode? themeMode,
    String? language,
    bool? notificationsEnabled,
  }) {
    return SettingsLoaded(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
