import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/custom_dialog.dart';

class BulkNotificationPage extends StatefulWidget {
  const BulkNotificationPage({super.key});

  @override
  State<BulkNotificationPage> createState() => _BulkNotificationPageState();
}

class _BulkNotificationPageState extends State<BulkNotificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final confirmed = await CustomDialog.showConfirmDialog(
      context,
      title: ArabicStrings.sendNotification,
      message: 'سيتم إرسال الإشعار إلى جميع المستخدمين. هل أنت متأكد؟',
      confirmText: ArabicStrings.send,
    );
    if (confirmed != true) return;
    setState(() => _isSending = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isSending = false);
      CustomSnackbar.showSuccess(context, 'تم إرسال الإشعار بنجاح');
      _titleController.clear();
      _bodyController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ArabicStrings.sendNotification)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_rounded, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'سيتم إرسال هذا الإشعار إلى جميع مستخدمي التطبيق',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.info),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _titleController,
                label: ArabicStrings.notificationTitle,
                hint: 'أدخل عنوان الإشعار',
                validator: (v) => v == null || v.trim().isEmpty ? ArabicStrings.titleRequired : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _bodyController,
                label: ArabicStrings.notificationBody,
                hint: 'أدخل نص الإشعار',
                maxLines: 5,
                validator: (v) => v == null || v.trim().isEmpty ? ArabicStrings.descriptionRequired : null,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: ArabicStrings.send,
                isLoading: _isSending,
                onPressed: _send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
