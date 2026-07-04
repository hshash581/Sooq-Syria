import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';

class AdminDrawer extends StatelessWidget {
  final String currentRoute;
  final VoidCallback? onLogout;

  const AdminDrawer({
    super.key,
    required this.currentRoute,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: AppColors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  ArabicStrings.adminPanel,
                  style: AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  ArabicStrings.statistics,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.white.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerMenuItem(
                  icon: Icons.dashboard_rounded,
                  title: 'لوحة التحكم',
                  isSelected: currentRoute == RoutesConfig.adminDashboard,
                  onTap: () => _navigate(context, RoutesConfig.adminDashboard),
                ),
                _DrawerMenuItem(
                  icon: Icons.pending_actions_rounded,
                  title: ArabicStrings.pendingAds,
                  isSelected: currentRoute == RoutesConfig.adminPendingAds,
                  onTap: () => _navigate(context, RoutesConfig.adminPendingAds),
                ),
                _DrawerMenuItem(
                  icon: Icons.check_circle_outline_rounded,
                  title: ArabicStrings.approvedAds,
                  isSelected: currentRoute == RoutesConfig.adminPendingAds,
                  onTap: () => _navigate(context, RoutesConfig.adminPendingAds),
                ),
                _DrawerMenuItem(
                  icon: Icons.cancel_outlined,
                  title: ArabicStrings.rejectedAds,
                  isSelected: currentRoute == RoutesConfig.adminPendingAds,
                  onTap: () => _navigate(context, RoutesConfig.adminPendingAds),
                ),
                const Divider(color: AppColors.divider, height: 1),
                _DrawerMenuItem(
                  icon: Icons.people_rounded,
                  title: ArabicStrings.totalUsers,
                  isSelected: currentRoute == RoutesConfig.adminUsers,
                  onTap: () => _navigate(context, RoutesConfig.adminUsers),
                ),
                _DrawerMenuItem(
                  icon: Icons.report_rounded,
                  title: ArabicStrings.report,
                  isSelected: currentRoute == RoutesConfig.adminReports,
                  onTap: () => _navigate(context, RoutesConfig.adminReports),
                ),
                _DrawerMenuItem(
                  icon: Icons.notifications_rounded,
                  title: ArabicStrings.sendNotification,
                  isSelected: currentRoute == RoutesConfig.adminNotifications,
                  onTap: () => _navigate(context, RoutesConfig.adminNotifications),
                ),
                const Divider(color: AppColors.divider, height: 1),
                _DrawerMenuItem(
                  icon: Icons.settings_rounded,
                  title: ArabicStrings.settings,
                  isSelected: currentRoute == RoutesConfig.adminSettings,
                  onTap: () => _navigate(context, RoutesConfig.adminSettings),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
              ),
              title: Text(
                ArabicStrings.logout,
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
              ),
              onTap: () {
                Navigator.pop(context);
                onLogout?.call();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    if (currentRoute != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.08) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          size: 22,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
