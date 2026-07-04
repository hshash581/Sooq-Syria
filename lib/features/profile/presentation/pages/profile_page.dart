import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: ArabicStrings.profile,
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Navigator.pushNamed(context, RoutesConfig.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 8),
            _buildStatsRow(),
            const SizedBox(height: 16),
            _buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.shimmerBase,
                child: Text(
                  Helpers.getInitials('محمد أحمد'),
                  style: AppTextStyles.displayMedium.copyWith(color: AppColors.textSecondary),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, RoutesConfig.editProfile),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.edit_rounded, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('محمد أحمد', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone_rounded, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text('+963 99 999 9999', style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_rounded, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text('دمشق، سوريا', style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: ArabicStrings.edit,
            isOutlined: true,
            onPressed: () => Navigator.pushNamed(context, RoutesConfig.editProfile),
            width: 160,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('12', ArabicStrings.ads),
          _buildStatDivider(),
          _buildStatItem('5', ArabicStrings.sales),
          _buildStatDivider(),
          _buildStatItem('24', ArabicStrings.favorites),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 40, color: AppColors.border);
  }

  Widget _buildMenuItems(BuildContext context) {
    final items = [
      _MenuItemData(Icons.list_alt_rounded, ArabicStrings.myAds, () => Navigator.pushNamed(context, RoutesConfig.myAds)),
      _MenuItemData(Icons.favorite_rounded, ArabicStrings.favorites, () => Navigator.pushNamed(context, RoutesConfig.favorites)),
      _MenuItemData(Icons.chat_rounded, ArabicStrings.chats, () => Navigator.pushNamed(context, RoutesConfig.chats)),
      _MenuItemData(Icons.settings_rounded, ArabicStrings.settings, () => Navigator.pushNamed(context, RoutesConfig.settings)),
      _MenuItemData(Icons.info_rounded, ArabicStrings.aboutApp, () => Navigator.pushNamed(context, RoutesConfig.settings)),
    ];

    return Column(
      children: [
        ...items.map((item) => ListTile(
          leading: Icon(item.icon, color: AppColors.primary),
          title: Text(item.title, style: AppTextStyles.bodyLarge),
          trailing: const Icon(Icons.arrow_back_ios_rounded, size: 16, color: AppColors.textHint),
          onTap: item.onTap,
        )),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout_rounded, color: AppColors.error),
          title: Text(ArabicStrings.logout, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error)),
          onTap: () {
            CustomDialog.showConfirmDialog(
              context,
              title: ArabicStrings.logout,
              message: 'هل أنت متأكد من تسجيل الخروج؟',
              isDestructive: true,
            ).then((confirmed) {
              if (confirmed == true) {
                Navigator.pushReplacementNamed(context, RoutesConfig.login);
              }
            });
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _MenuItemData(this.icon, this.title, this.onTap);
}
