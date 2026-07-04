import '../repositories/settings_repository.dart';

class SetLanguage {
  final SettingsRepository repository;
  SetLanguage(this.repository);

  Future<void> call(String lang) {
    return repository.setLanguage(lang);
  }
}
