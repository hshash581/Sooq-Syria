import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../../../categories/domain/entities/category_entity.dart';

class CategoryListItem extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback? onTap;
  final double? width;

  const CategoryListItem({
    super.key,
    required this.category,
    this.onTap,
    this.width,
  });

  static const Map<String, IconData> _iconMap = {
    'real_estate': Icons.home_work_rounded,
    'cars': Icons.directions_car_rounded,
    'electronics': Icons.devices_rounded,
    'furniture': Icons.chair_rounded,
    'clothing': Icons.checkroom_rounded,
    'services': Icons.build_rounded,
    'pets': Icons.pets_rounded,
    'jobs': Icons.work_rounded,
    'phones': Icons.phone_rounded,
    'books': Icons.book_rounded,
    'sports': Icons.sports_tennis_rounded,
    'music': Icons.music_note_rounded,
  };

  static const List<IconData> _defaultIcons = [
    Icons.category_rounded,
    Icons.shopping_bag_rounded,
    Icons.store_rounded,
    Icons.inventory_2_rounded,
    Icons.widgets_rounded,
    Icons.apps_rounded,
  ];

  IconData _getIcon() {
    if (category.icon != null && _iconMap.containsKey(category.icon)) {
      return _iconMap[category.icon]!;
    }
    return _defaultIcons[category.order % _defaultIcons.length];
  }

  Color _getColor() {
    if (category.color == null) return AppColors.primary;
    try {
      final hex = category.color!.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final icon = _getIcon();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              category.name,
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (category.adsCount > 0) ...[
              const SizedBox(height: 4),
              Text(
                '${Helpers.formatCount(category.adsCount)} ${category.adsCount == 1 ? 'إعلان' : 'إعلانات'}',
                style: AppTextStyles.caption,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
