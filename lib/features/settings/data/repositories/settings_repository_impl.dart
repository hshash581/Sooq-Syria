import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<String> getThemeMode() async {
    try {
      return localDataSource.getThemeMode();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> setThemeMode(String mode) async {
    try {
      await localDataSource.setThemeMode(mode);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getLanguage() async {
    try {
      return localDataSource.getLanguage();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> setLanguage(String lang) async {
    try {
      await localDataSource.setLanguage(lang);
    } catch (e) {
      rethrow;
    }
  }
}
