import 'package:flutter/material.dart' hide DateUtils;
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/date_utils.dart';

class AdInfoSection extends StatelessWidget {
  final double price;
  final String? currency;
  final String condition;
  final bool isNegotiable;
  final DateTime createdAt;
  final int viewsCount;
  final int likesCount;
  final bool isNew;

  const AdInfoSection({
    super.key,
    required this.price,
    this.currency,
    required this.condition,
    required this.isNegotiable,
    required this.createdAt,
    required this.viewsCount,
    required this.likesCount,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Helpers.formatPrice(price, currency: currency ?? 'SYP'),
                    style: AppTextStyles.price,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _conditionColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          condition,
                          style: AppTextStyles.caption.copyWith(color: _conditionColor),
                        ),
                      ),
                      if (isNegotiable) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ArabicStrings.negotiable,
                            style: AppTextStyles.caption.copyWith(color: AppColors.accent),
                          ),
                        ),
                      ],
                      if (isNew) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ArabicStrings.newItem,
                            style: AppTextStyles.caption.copyWith(color: AppColors.success),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(color: AppColors.divider),
        const SizedBox(height: 8),
        _buildInfoRow(Icons.access_time_rounded, '${DateUtils.timeAgo(createdAt)}'),
        const SizedBox(height: 8),
        _buildInfoRow(Icons.visibility_rounded, '${Helpers.formatCount(viewsCount)} ${ArabicStrings.views}'),
        const SizedBox(height: 8),
        _buildInfoRow(Icons.favorite_rounded, '${Helpers.formatCount(likesCount)} ${ArabicStrings.likes}'),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyles.bodyMedium),
      ],
    );
  }

  Color get _conditionColor {
    if (condition == ArabicStrings.newItem) return AppColors.success;
    return AppColors.warning;
  }
}
