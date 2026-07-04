import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class ReportPage extends StatefulWidget {
  final String adId;

  const ReportPage({super.key, required this.adId});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String? _selectedReason;
  bool _isSubmitting = false;

  final List<String> _reasons = [
    ArabicStrings.spam,
    ArabicStrings.inappropriate,
    ArabicStrings.fake,
    ArabicStrings.duplicate,
    ArabicStrings.other,
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _isSubmitting = false);
        CustomSnackbar.showSuccess(context, ArabicStrings.reportSent);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ArabicStrings.report)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flag_rounded, size: 32, color: AppColors.error),
              ),
              const SizedBox(height: 16),
              Text(
                ArabicStrings.reportSubject,
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '${ArabicStrings.report} #${widget.adId}',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              Text(ArabicStrings.reportReason, style: AppTextStyles.titleLarge),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedReason,
                decoration: const InputDecoration(
                  hintText: ArabicStrings.reportReason,
                  filled: true,
                ),
                items: _reasons.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setState(() => _selectedReason = v),
                validator: (v) => v == null ? ArabicStrings.reasonRequired : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'وصف المشكلة',
                hint: ArabicStrings.reportHint,
                maxLines: 5,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: ArabicStrings.submit,
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
