import '../../../../core/services/local_storage_service.dart';

class SettingsLocalDataSource {
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _notificationKey = 'notifications_enabled';
  static const String _onboardingKey = 'onboarding_completed';

  final LocalStorageService _storageService = LocalStorageService();

  String getThemeMode() {
    return _storageService.getString(_themeKey, defaultValue: 'system');
  }

  Future<void> setThemeMode(String mode) async {
    await _storageService.setString(_themeKey, mode);
  }

  String getLanguage() {
    return _storageService.getString(_languageKey, defaultValue: 'ar');
  }

  Future<void> setLanguage(String language) async {
    await _storageService.setString(_languageKey, language);
  }

  bool getNotificationEnabled() {
    return _storageService.getBool(_notificationKey, defaultValue: true);
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    await _storageService.setBool(_notificationKey, enabled);
  }

  bool isOnboardingCompleted() {
    return _storageService.getBool(_onboardingKey, defaultValue: false);
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _storageService.setBool(_onboardingKey, completed);
  }
}
