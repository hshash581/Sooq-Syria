import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _remoteConfig.fetchAndActivate();
  }

  String getString(String key) => _remoteConfig.getString(key);
  bool getBool(String key) => _remoteConfig.getBool(key);
  int getInt(String key) => _remoteConfig.getInt(key);
  double getDouble(String key) => _remoteConfig.getDouble(key);

  bool get isMaintenanceMode => getBool('maintenance_mode');
  String get maintenanceMessage => getString('maintenance_message');
  String get appVersion => getString('app_version');
  bool get requirePhoneVerification => getBool('require_phone_verification');
  int get maxAdImages => getInt('max_ad_images');
  bool get adApprovalRequired => getBool('ad_approval_required');
  int get adListingPrice => getInt('ad_listing_price');
  String get defaultCurrency => getString('default_currency');
  List<String> get supportedCurrencies =>
      getString('supported_currencies').split(',');
  String get contactEmail => getString('contact_email');
  String get privacyPolicyUrl => getString('privacy_policy_url');
  String get termsUrl => getString('terms_url');
}
