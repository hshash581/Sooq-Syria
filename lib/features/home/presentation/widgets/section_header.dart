import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAllTap;
  final bool showViewAll;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final String? viewAllText;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAllTap,
    this.showViewAll = true,
    this.leadingIcon,
    this.leadingIconColor,
    this.viewAllText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, color: leadingIconColor ?? AppColors.accent, size: 20),
                const SizedBox(width: 6),
              ],
              Text(title, style: AppTextStyles.titleLarge),
            ],
          ),
          if (showViewAll)
            TextButton(
              onPressed: onViewAllTap,
              child: Text(
                viewAllText ?? ArabicStrings.viewAll,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
