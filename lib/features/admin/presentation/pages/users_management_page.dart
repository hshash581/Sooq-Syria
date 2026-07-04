import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _users = List.generate(
    8,
    (i) => {
      'id': i.toString(),
      'name': 'مستخدم ${i + 1}',
      'phone': '+963 99 999 999${i}',
      'isBlocked': i == 2 || i == 5,
      'isVerified': i.isEven,
      'adsCount': i * 3,
    },
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleBlock(int index) {
    final user = _users[index];
    final action = (user['isBlocked'] as bool) ? ArabicStrings.unblockUser : ArabicStrings.blockUser;
    CustomDialog.showConfirmDialog(
      context,
      title: action,
      message: '${action} ${user['name']}?',
      isDestructive: !(user['isBlocked'] as bool),
    ).then((confirmed) {
      if (confirmed == true) {
        setState(() => user['isBlocked'] = !(user['isBlocked'] as bool));
        CustomSnackbar.showSuccess(context, '${(user['isBlocked'] as bool) ? 'تم الحظر' : 'تم إلغاء الحظر'}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ArabicStrings.totalUsers),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'بحث عن مستخدم...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final isBlocked = user['isBlocked'] as bool;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isBlocked ? AppColors.error.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.person_rounded,
                        color: isBlocked ? AppColors.error : AppColors.primary,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(user['name'] as String, style: AppTextStyles.titleMedium),
                        if (user['isVerified'] as bool)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(Icons.verified_rounded, size: 16, color: AppColors.primary),
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user['phone'] as String, style: AppTextStyles.bodySmall, textDirection: TextDirection.ltr),
                        Text('${user['adsCount']} إعلانات', style: AppTextStyles.caption),
                      ],
                    ),
                    trailing: Switch(
                      value: isBlocked,
                      activeThumbColor: AppColors.error,
                      onChanged: (_) => _toggleBlock(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
