import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';

class MainPage extends StatelessWidget {
  final Widget child;

  const MainPage({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/categories')) return 1;
    if (location.startsWith('/favorites')) return 3;
    if (location.startsWith('/profile')) return 4;
    if (location.startsWith('/chats')) return 3;
    return 0;
  }

  void _onTabTapped(int index, BuildContext context) {
    if (index == 2) {
      context.push(RoutesConfig.createAd);
      return;
    }
    switch (index) {
      case 0:
        context.go(RoutesConfig.home);
        break;
      case 1:
        context.go(RoutesConfig.categories);
        break;
      case 3:
        context.go(RoutesConfig.favorites);
        break;
      case 4:
        context.go(RoutesConfig.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTabTapped(index, context),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            activeIcon: const Icon(Icons.home_rounded),
            label: ArabicStrings.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.category_rounded),
            activeIcon: const Icon(Icons.category_rounded),
            label: ArabicStrings.categories,
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_rounded),
            activeIcon: const Icon(Icons.favorite_rounded),
            label: ArabicStrings.favorites,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_rounded),
            activeIcon: const Icon(Icons.person_rounded),
            label: ArabicStrings.profile,
          ),
        ],
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyles.labelSmall,
      ),
    );
  }
}
