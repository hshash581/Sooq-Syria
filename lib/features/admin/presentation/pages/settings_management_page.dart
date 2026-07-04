import 'package:flutter/material.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';

import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/custom_dialog.dart';

class SettingsManagementPage extends StatefulWidget {
  const SettingsManagementPage({super.key});

  @override
  State<SettingsManagementPage> createState() => _SettingsManagementPageState();
}

class _SettingsManagementPageState extends State<SettingsManagementPage> {
  bool _approvalRequired = true;
  String _defaultCurrency = AppConfig.defaultCurrency;

  final List<String> _categories = ['عقارات', 'سيارات', 'إلكترونيات', 'أثاث', 'ملابس', 'خدمات', 'حيوانات', 'وظائف'];
  final List<String> _governorates = List.from(AppConfig.governorates);

  void _addItem(String type) async {
    final name = await CustomDialog.showInputDialog(
      context,
      title: 'إضافة ${type == 'categories' ? 'قسم' : type == 'governorates' ? 'محافظة' : 'مدينة'}',
      hint: 'أدخل الاسم',
    );
    if (name != null && name.trim().isNotEmpty) {
      setState(() {
        if (type == 'categories') _categories.add(name.trim());
        if (type == 'governorates') _governorates.add(name.trim());
      });
      CustomSnackbar.showSuccess(context, 'تمت الإضافة');
    }
  }

  void _editItem(String type, int index, String currentName) async {
    final name = await CustomDialog.showInputDialog(
      context,
      title: 'تعديل',
      hint: currentName,
    );
    if (name != null && name.trim().isNotEmpty) {
      setState(() {
        if (type == 'categories') _categories[index] = name.trim();
        if (type == 'governorates') _governorates[index] = name.trim();
      });
      CustomSnackbar.showSuccess(context, 'تم التعديل');
    }
  }

  void _deleteItem(String type, int index) async {
    final confirmed = await CustomDialog.showConfirmDialog(
      context,
      title: ArabicStrings.delete,
      message: 'هل أنت متأكد من الحذف؟',
      isDestructive: true,
    );
    if (confirmed == true) {
      setState(() {
        if (type == 'categories') _categories.removeAt(index);
        if (type == 'governorates') _governorates.removeAt(index);
      });
      CustomSnackbar.showSuccess(context, 'تم الحذف');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ArabicStrings.settings)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsSection(),
            const SizedBox(height: 24),
            _buildListSection('الأقسام', _categories, 'categories'),
            const SizedBox(height: 24),
            _buildListSection('المحافظات', _governorates, 'governorates'),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('إعدادات التطبيق', style: AppTextStyles.titleLarge),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text('طلب الموافقة على الإعلانات'),
              subtitle: Text('عند التفعيل، يجب مراجعة الإعلان قبل النشر'),
              value: _approvalRequired,
              onChanged: (v) => setState(() => _approvalRequired = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('العملة الافتراضية'),
              trailing: DropdownButton<String>(
                value: _defaultCurrency,
                underline: const SizedBox(),
                items: AppConfig.currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _defaultCurrency = v);
                    CustomSnackbar.showSuccess(context, 'تم الحفظ');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSection(String title, List<String> items, String type) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.titleLarge),
                IconButton(
                  icon: const Icon(Icons.add_circle_rounded, color: AppColors.primary),
                  onPressed: () => _addItem(type),
                ),
              ],
            ),
            const Divider(),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text('لا توجد عناصر', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                ),
              )
            else
              ...List.generate(
                items.length,
                (index) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(items[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_rounded, size: 18, color: AppColors.primary),
                        onPressed: () => _editItem(type, index, items[index]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_rounded, size: 18, color: AppColors.error),
                        onPressed: () => _deleteItem(type, index),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
