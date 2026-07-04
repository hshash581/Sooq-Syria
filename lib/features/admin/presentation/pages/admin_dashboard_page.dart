import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: ArabicStrings.adminPanel,
        showBack: false,
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ArabicStrings.statistics, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            _buildStatsGrid(),
            const SizedBox(height: 24),
            Text(ArabicStrings.adminPanel, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            _buildMenuGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(ArabicStrings.totalAds, '1,245', Icons.sell_rounded, AppColors.primary, Colors.blue.shade50),
        _buildStatCard(ArabicStrings.totalUsers, '3,567', Icons.people_rounded, AppColors.secondary, Colors.green.shade50),
        _buildStatCard(ArabicStrings.totalViews, '89K', Icons.visibility_rounded, AppColors.info, Colors.blue.shade50),
        _buildStatCard(ArabicStrings.totalReports, '23', Icons.flag_rounded, AppColors.error, Colors.red.shade50),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          Text(value, style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold)),
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    final items = [
      _AdminMenuItem(ArabicStrings.pendingAds, Icons.pending_actions_rounded, AppColors.warning, RoutesConfig.adminPendingAds),
      _AdminMenuItem(ArabicStrings.totalUsers, Icons.people_rounded, AppColors.primary, RoutesConfig.adminUsers),
      _AdminMenuItem(ArabicStrings.totalReports, Icons.flag_rounded, AppColors.error, RoutesConfig.adminReports),
      _AdminMenuItem(ArabicStrings.sendNotification, Icons.notifications_rounded, AppColors.info, RoutesConfig.adminNotifications),
      _AdminMenuItem(ArabicStrings.settings, Icons.settings_rounded, AppColors.textSecondary, RoutesConfig.adminSettings),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, item.route),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color, size: 28),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    item.title,
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings_rounded, size: 36, color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                Text('الإدارة', style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
                Text(ArabicStrings.adminPanel, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.dashboard_rounded), title: const Text('لوحة التحكم'), onTap: () { Navigator.pop(context); }),
          ListTile(leading: const Icon(Icons.pending_actions_rounded), title: const Text(ArabicStrings.pendingAds), onTap: () { Navigator.pop(context); Navigator.pushNamed(context, RoutesConfig.adminPendingAds); }),
          ListTile(leading: const Icon(Icons.people_rounded), title: const Text(ArabicStrings.totalUsers), onTap: () { Navigator.pop(context); Navigator.pushNamed(context, RoutesConfig.adminUsers); }),
          ListTile(leading: const Icon(Icons.flag_rounded), title: const Text(ArabicStrings.totalReports), onTap: () { Navigator.pop(context); Navigator.pushNamed(context, RoutesConfig.adminReports); }),
          ListTile(leading: const Icon(Icons.notifications_rounded), title: const Text(ArabicStrings.sendNotification), onTap: () { Navigator.pop(context); Navigator.pushNamed(context, RoutesConfig.adminNotifications); }),
          ListTile(leading: const Icon(Icons.settings_rounded), title: const Text(ArabicStrings.settings), onTap: () { Navigator.pop(context); Navigator.pushNamed(context, RoutesConfig.adminSettings); }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: const Text(ArabicStrings.logout, style: TextStyle(color: AppColors.error)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, RoutesConfig.login);
            },
          ),
        ],
      ),
    );
  }
}

class _AdminMenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  _AdminMenuItem(this.title, this.icon, this.color, this.route);
}
