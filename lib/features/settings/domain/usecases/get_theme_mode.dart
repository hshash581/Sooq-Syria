import '../repositories/settings_repository.dart';

class GetThemeMode {
  final SettingsRepository repository;
  GetThemeMode(this.repository);

  Future<String> call() {
    return repository.getThemeMode();
  }
}
