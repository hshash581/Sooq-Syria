import 'package:flutter/material.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _language = 'ar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ArabicStrings.settings),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildSection('العرض', [
            SwitchListTile(
              secondary: Icon(_isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: AppColors.primary),
              title: Text(_isDarkMode ? ArabicStrings.darkMode : ArabicStrings.lightMode),
              value: _isDarkMode,
              onChanged: (v) => setState(() => _isDarkMode = v),
            ),
            ListTile(
              leading: const Icon(Icons.language_rounded, color: AppColors.primary),
              title: Text(ArabicStrings.language),
              trailing: DropdownButton<String>(
                value: _language,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'ar', child: Text(ArabicStrings.arabic)),
                  DropdownMenuItem(value: 'en', child: Text(ArabicStrings.english)),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _language = v);
                    CustomSnackbar.showSuccess(context, 'تم تغيير اللغة');
                  }
                },
              ),
            ),
          ]),
          _buildSection('الإشعارات', [
            SwitchListTile(
              secondary: const Icon(Icons.notifications_rounded, color: AppColors.primary),
              title: Text('الإشعارات'),
              value: _notificationsEnabled,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
            ),
          ]),
          _buildSection('معلومات التطبيق', [
            ListTile(
              leading: const Icon(Icons.privacy_tip_rounded, color: AppColors.primary),
              title: Text(ArabicStrings.privacyPolicy),
              trailing: const Icon(Icons.arrow_back_ios_rounded, size: 16, color: AppColors.textHint),
              onTap: () => Helpers.openUrl('https://sooqsyr.app/privacy'),
            ),
            ListTile(
              leading: const Icon(Icons.description_rounded, color: AppColors.primary),
              title: Text(ArabicStrings.termsOfService),
              trailing: const Icon(Icons.arrow_back_ios_rounded, size: 16, color: AppColors.textHint),
              onTap: () => Helpers.openUrl('https://sooqsyr.app/terms'),
            ),
            ListTile(
              leading: const Icon(Icons.star_rounded, color: AppColors.rating),
              title: Text(ArabicStrings.rateApp),
              trailing: const Icon(Icons.arrow_back_ios_rounded, size: 16, color: AppColors.textHint),
              onTap: Helpers.rateApp,
            ),
            ListTile(
              leading: const Icon(Icons.share_rounded, color: AppColors.primary),
              title: Text(ArabicStrings.shareApp),
              trailing: const Icon(Icons.arrow_back_ios_rounded, size: 16, color: AppColors.textHint),
              onTap: Helpers.shareApp,
            ),
            ListTile(
              leading: const Icon(Icons.info_rounded, color: AppColors.info),
              title: Text(ArabicStrings.aboutApp),
              subtitle: Text('${ArabicStrings.version} ${AppConfig.version}'),
              trailing: const Icon(Icons.arrow_back_ios_rounded, size: 16, color: AppColors.textHint),
              onTap: () {
                CustomDialog.showInfoDialog(
                  context,
                  title: ArabicStrings.aboutApp,
                  message: '${ArabicStrings.appName}\n${ArabicStrings.version} ${AppConfig.version}\n\nتطبيق لبيع وشراء المنتجات في سوريا',
                );
              },
            ),
          ]),
          _buildSection('الحساب', [
            ListTile(
              leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
              title: Text(ArabicStrings.deleteAccount, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error)),
              onTap: () {
                CustomDialog.showConfirmDialog(
                  context,
                  title: ArabicStrings.deleteAccount,
                  message: ArabicStrings.deleteAccountConfirm,
                  isDestructive: true,
                  confirmText: ArabicStrings.delete,
                ).then((confirmed) {
                  if (confirmed == true) {
                    CustomSnackbar.showSuccess(context, 'تم حذف الحساب');
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                });
              },
            ),
          ]),
          const SizedBox(height: 32),
          Center(
            child: Text(
              '${ArabicStrings.appName} v${AppConfig.version}',
              style: AppTextStyles.caption,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(title, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(children: children),
        ),
      ],
    );
  }
}
