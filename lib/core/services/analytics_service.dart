import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get analytics => _analytics;

  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> logLogin() async {
    await _analytics.logEvent(name: 'login');
  }

  Future<void> logSignUp() async {
    await _analytics.logEvent(name: 'sign_up');
  }

  Future<void> logShare({
    required String contentType,
    required String itemId,
  }) async {
    await _analytics.logEvent(
      name: 'share',
      parameters: {
        'content_type': contentType,
        'item_id': itemId,
      },
    );
  }

  Future<void> logViewItem({
    required String itemId,
    required String itemName,
    required String itemCategory,
  }) async {
    await _analytics.logEvent(
      name: 'view_item',
      parameters: {
        'item_id': itemId,
        'item_name': itemName,
        'item_category': itemCategory,
      },
    );
  }

  Future<void> logAddFavorite(String itemId) async {
    await _analytics.logEvent(
      name: 'add_to_wishlist',
      parameters: {
        'item_id': itemId,
        'currency': 'SYP',
        'value': 0,
      },
    );
  }
}
