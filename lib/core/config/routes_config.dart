import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages.dart';

class RoutesConfig {
  static const String splash = '/';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String register = '/register';
  static const String completeProfile = '/complete-profile';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String adDetail = '/ad/:id';
  static const String createAd = '/create-ad';
  static const String editAd = '/edit-ad/:id';
  static const String myAds = '/my-ads';
  static const String editProfile = '/edit-profile';
  static const String chats = '/chats';
  static const String chatDetail = '/chat/:id';
  static const String notifications = '/notifications';
  static const String search = '/search';
  static const String searchFilters = '/search/filters';
  static const String categoryAds = '/category/:id';
  static const String settings = '/settings';
  static const String report = '/report/:adId';
  static const String adminDashboard = '/admin';
  static const String adminPendingAds = '/admin/pending-ads';
  static const String adminUsers = '/admin/users';
  static const String adminReports = '/admin/reports';
  static const String adminNotifications = '/admin/notifications';
  static const String adminSettings = '/admin/settings';
}

class OtpPageArguments {
  final String phone;
  final String verificationId;

  const OtpPageArguments({required this.phone, required this.verificationId});
}

class AppRouter {
  AppRouter._();

  static final GoRouterNotifier _authNotifier = GoRouterNotifier();

  static final GoRouter router = GoRouter(
    initialLocation: RoutesConfig.splash,
    refreshListenable: _authNotifier,
    redirect: _redirect,
    routes: _routes,
  );

  static const _publicRoutes = <String>{
    RoutesConfig.splash,
    RoutesConfig.login,
    RoutesConfig.register,
    RoutesConfig.otp,
  };

  static String? _redirect(BuildContext context, GoRouterState state) {
    final isAuthenticated = _authNotifier.isAuthenticated;
    final location = state.matchedLocation;

    if (_publicRoutes.contains(location)) {
      return null;
    }

    final isPublicPrefix =
        location.startsWith('/ad/') ||
        location.startsWith('/category/') ||
        location.startsWith('/search');

    if (isPublicPrefix) {
      return null;
    }

    if (!isAuthenticated) {
      return RoutesConfig.login;
    }

    return null;
  }

  static void updateAuthState(bool isAuthenticated) {
    _authNotifier.update(isAuthenticated);
  }

  static final List<RouteBase> _routes = [
    GoRoute(path: RoutesConfig.splash, builder: (_, __) => const SplashPage()),
    GoRoute(path: RoutesConfig.login, builder: (_, __) => const LoginPage()),
    GoRoute(
      path: RoutesConfig.otp,
      builder: (_, state) {
        final args = state.extra as OtpPageArguments;
        return OtpPage(phone: args.phone, verificationId: args.verificationId);
      },
    ),
    GoRoute(
      path: RoutesConfig.register,
      builder: (_, __) => const RegisterPage(),
    ),
    GoRoute(
      path: RoutesConfig.completeProfile,
      builder: (_, __) => const CompleteProfilePage(),
    ),
    GoRoute(
      path: '/ad/:id',
      builder: (_, state) => AdDetailPage(adId: state.pathParameters['id']!),
      routes: [
        GoRoute(
          path: 'report',
          builder: (_, state) => ReportPage(adId: state.pathParameters['id']!),
        ),
      ],
    ),
    GoRoute(
      path: RoutesConfig.createAd,
      builder: (_, __) => const CreateAdPage(),
    ),
    GoRoute(
      path: '/edit-ad/:id',
      builder: (_, state) => EditAdPage(adId: state.pathParameters['id']!),
    ),
    GoRoute(path: RoutesConfig.myAds, builder: (_, __) => const MyAdsPage()),
    GoRoute(
      path: RoutesConfig.editProfile,
      builder: (_, __) => const EditProfilePage(),
    ),
    GoRoute(path: RoutesConfig.chats, builder: (_, __) => const ChatsPage()),
    GoRoute(
      path: '/chat/:id',
      builder: (_, state) =>
          ChatDetailPage(chatId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: RoutesConfig.notifications,
      builder: (_, __) => const NotificationsPage(),
    ),
    GoRoute(path: RoutesConfig.search, builder: (_, __) => const SearchPage()),
    GoRoute(
      path: RoutesConfig.searchFilters,
      builder: (_, __) => const SearchFiltersPage(),
    ),
    GoRoute(
      path: '/category/:id',
      builder: (_, state) =>
          CategoryAdsPage(categoryName: state.extra as String),
    ),
    GoRoute(
      path: RoutesConfig.settings,
      builder: (_, __) => const SettingsPage(),
    ),
    GoRoute(
      path: '/report/:adId',
      builder: (_, state) => ReportPage(adId: state.pathParameters['adId']!),
    ),
    GoRoute(
      path: RoutesConfig.adminDashboard,
      builder: (_, __) => const AdminDashboardPage(),
    ),
    GoRoute(
      path: RoutesConfig.adminPendingAds,
      builder: (_, __) => const PendingAdsPage(),
    ),
    GoRoute(
      path: RoutesConfig.adminUsers,
      builder: (_, __) => const UsersManagementPage(),
    ),
    GoRoute(
      path: RoutesConfig.adminReports,
      builder: (_, __) => const ReportsManagementPage(),
    ),
    GoRoute(
      path: RoutesConfig.adminNotifications,
      builder: (_, __) => const BulkNotificationPage(),
    ),
    GoRoute(
      path: RoutesConfig.adminSettings,
      builder: (_, __) => const SettingsManagementPage(),
    ),
    ShellRoute(
      builder: (_, __, child) => MainPage(child: child),
      routes: [
        GoRoute(path: RoutesConfig.home, builder: (_, __) => const HomePage()),
        GoRoute(
          path: RoutesConfig.categories,
          builder: (_, __) => const CategoriesPage(),
        ),
        GoRoute(
          path: RoutesConfig.favorites,
          builder: (_, __) => const FavoritesPage(),
        ),
        GoRoute(
          path: RoutesConfig.profile,
          builder: (_, __) => const ProfilePage(),
        ),
      ],
    ),
  ];
}

class GoRouterNotifier extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  void update(bool isAuthenticated) {
    if (_isAuthenticated != isAuthenticated) {
      _isAuthenticated = isAuthenticated;
      notifyListeners();
    }
  }
}
