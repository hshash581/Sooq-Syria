import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/custom_button.dart';

class ContactButtons extends StatelessWidget {
  final String phoneNumber;
  final bool showNumber;
  final VoidCallback? onShowNumber;
  final VoidCallback? onMessageTap;

  const ContactButtons({
    super.key,
    required this.phoneNumber,
    this.showNumber = false,
    this.onShowNumber,
    this.onMessageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showNumber)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      phoneNumber,
                      style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary),
                      textDirection: TextDirection.ltr,
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                  ],
                ),
              ),
            Row(
              children: [
                if (!showNumber)
                  Expanded(
                    child: CustomButton(
                      text: ArabicStrings.showNumber,
                      isOutlined: true,
                      onPressed: onShowNumber,
                    ),
                  ),
                if (showNumber) ...[
                  Expanded(
                    child: CustomButton(
                      text: ArabicStrings.call,
                      icon: Icons.phone_rounded,
                      onPressed: () => Helpers.makePhoneCall(phoneNumber),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      text: ArabicStrings.whatsapp,
                      icon: Icons.chat_rounded,
                      color: AppColors.whatsapp,
                      onPressed: () => Helpers.openWhatsApp(phoneNumber),
                    ),
                  ),
                ],
                if (!showNumber) const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: ArabicStrings.message,
                    icon: Icons.email_rounded,
                    isOutlined: !showNumber,
                    onPressed: onMessageTap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
