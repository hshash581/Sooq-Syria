class AppConfig {
  static const String appName = 'سوق سوريا';
  static const String appNameEn = 'Sooq Syria';
  static const String version = '1.0.0';
  static const String defaultCountryCode = '+963';
  static const int maxAdImages = 10;
  static const int pageSize = 20;
  static const int skeletonItemCount = 6;
  static const Duration cacheDuration = Duration(hours: 24);
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration locationTimeout = Duration(seconds: 30);
  static const List<String> currencies = ['SYP', 'USD', 'EUR', 'TRY'];
  static const String defaultCurrency = 'SYP';

  static const List<String> governorates = [
    'دمشق',
    'حلب',
    'حمص',
    'اللاذقية',
    'حماة',
    'طرطوس',
    'دير الزور',
    'الرقة',
    'إدلب',
    'الحسكة',
    'درعا',
    'السويداء',
    'القنيطرة',
  ];
}
