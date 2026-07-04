import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsLoaded extends SettingsState {
  final ThemeMode themeMode;
  final String language;
  final bool notificationsEnabled;

  const SettingsLoaded({
    required this.themeMode,
    required this.language,
    required this.notificationsEnabled,
  });

  @override
  List<Object?> get props => [themeMode, language, notificationsEnabled];
}

class SettingsUpdated extends SettingsState {
  const SettingsUpdated();
}
