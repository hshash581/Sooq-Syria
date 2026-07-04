import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';

class PhoneInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final String selectedCode;
  final ValueChanged<String> onCodeChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const PhoneInputWidget({
    super.key,
    required this.controller,
    this.selectedCode = '+963',
    required this.onCodeChanged,
    this.validator,
    this.focusNode,
  });

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget> {
  final List<Map<String, String>> _countryCodes = [
    {'code': '+963', 'flag': '🇸🇾', 'name': 'سوريا'},
    {'code': '+966', 'flag': '🇸🇦', 'name': 'السعودية'},
    {'code': '+971', 'flag': '🇦🇪', 'name': 'الإمارات'},
    {'code': '+962', 'flag': '🇯🇴', 'name': 'الأردن'},
    {'code': '+961', 'flag': '🇱🇧', 'name': 'لبنان'},
    {'code': '+964', 'flag': '🇮🇶', 'name': 'العراق'},
    {'code': '+905', 'flag': '🇹🇷', 'name': 'تركيا'},
  ];

  late String _selectedCode;

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.selectedCode;
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'اختر الدولة',
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 16),
            ...List.generate(_countryCodes.length, (index) {
              final country = _countryCodes[index];
              return ListTile(
                leading: Text(country['flag']!, style: const TextStyle(fontSize: 28)),
                title: Text(
                  '${country['name']} (${country['code']})',
                  style: AppTextStyles.bodyLarge,
                ),
                trailing: _selectedCode == country['code']
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  widget.onCodeChanged(country['code']!);
                  setState(() => _selectedCode = country['code']!);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        validator: widget.validator,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          hintText: '99xxxxxxx',
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
          prefixIcon: InkWell(
            onTap: _showCountryPicker,
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                textDirection: TextDirection.ltr,
                children: [
                  Text(
                    _selectedCode,
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                  const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary),
                ],
              ),
            ),
          ),
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
        ),
      ),
    );
  }
}
