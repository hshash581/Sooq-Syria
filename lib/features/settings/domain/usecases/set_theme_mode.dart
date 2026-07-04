import '../repositories/settings_repository.dart';

class SetThemeMode {
  final SettingsRepository repository;
  SetThemeMode(this.repository);

  Future<void> call(String mode) {
    return repository.setThemeMode(mode);
  }
}
