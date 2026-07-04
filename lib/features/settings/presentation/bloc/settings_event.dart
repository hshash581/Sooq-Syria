import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class ToggleDarkMode extends SettingsEvent {
  const ToggleDarkMode();
}

class ToggleNotifications extends SettingsEvent {
  const ToggleNotifications();
}

class ChangeLanguage extends SettingsEvent {
  final String language;

  const ChangeLanguage(this.language);

  @override
  List<Object?> get props => [language];
}
