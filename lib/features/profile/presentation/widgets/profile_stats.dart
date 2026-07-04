import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/helpers.dart';

class ProfileStats extends StatelessWidget {
  final int adsCount;
  final int salesCount;
  final int favoritesCount;

  const ProfileStats({
    super.key,
    required this.adsCount,
    required this.salesCount,
    required this.favoritesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.post_add_rounded,
              label: ArabicStrings.ads,
              count: adsCount,
              color: AppColors.primary,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _buildStatItem(
              icon: Icons.shopping_cart_rounded,
              label: ArabicStrings.sales,
              count: salesCount,
              color: AppColors.secondary,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _buildStatItem(
              icon: Icons.favorite_rounded,
              label: ArabicStrings.favorites,
              count: favoritesCount,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          Helpers.formatCount(count),
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 48,
      color: AppColors.divider,
    );
  }
}
