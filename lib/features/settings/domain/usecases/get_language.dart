import '../repositories/settings_repository.dart';

class GetLanguage {
  final SettingsRepository repository;
  GetLanguage(this.repository);

  Future<String> call() {
    return repository.getLanguage();
  }
}
