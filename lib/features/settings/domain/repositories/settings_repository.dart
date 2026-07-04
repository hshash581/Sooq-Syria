abstract class SettingsRepository {
  Future<String> getThemeMode();
  Future<void> setThemeMode(String mode);
  Future<String> getLanguage();
  Future<void> setLanguage(String lang);
}
