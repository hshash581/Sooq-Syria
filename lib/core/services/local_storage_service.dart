import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) throw Exception('LocalStorageService not initialized');
    return _prefs!;
  }

  String getString(String key, {String defaultValue = ''}) {
    return prefs.getString(key) ?? defaultValue;
  }

  Future<bool> setString(String key, String value) {
    return prefs.setString(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return prefs.getBool(key) ?? defaultValue;
  }

  Future<bool> setBool(String key, bool value) {
    return prefs.setBool(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return prefs.getInt(key) ?? defaultValue;
  }

  Future<bool> setInt(String key, int value) {
    return prefs.setInt(key, value);
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    return prefs.getDouble(key) ?? defaultValue;
  }

  Future<bool> setDouble(String key, double value) {
    return prefs.setDouble(key, value);
  }

  Future<bool> remove(String key) {
    return prefs.remove(key);
  }

  Future<bool> clear() {
    return prefs.clear();
  }
}
