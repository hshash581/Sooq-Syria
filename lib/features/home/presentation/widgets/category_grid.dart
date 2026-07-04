import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';
import '../../../categories/domain/entities/category_entity.dart';

class CategoryGrid extends StatelessWidget {
  final List<CategoryEntity> categories;
  final bool showTitle;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;

  const CategoryGrid({
    super.key,
    required this.categories,
    this.showTitle = true,
    this.showViewAll = true,
    this.onViewAllTap,
  });

  static const List<IconData> _defaultIcons = [
    Icons.home_work_rounded,
    Icons.directions_car_rounded,
    Icons.devices_rounded,
    Icons.chair_rounded,
    Icons.checkroom_rounded,
    Icons.build_rounded,
    Icons.pets_rounded,
    Icons.work_rounded,
    Icons.phone_rounded,
    Icons.book_rounded,
    Icons.sports_tennis_rounded,
    Icons.music_note_rounded,
  ];

  IconData _getCategoryIcon(String? iconName, int index) {
    if (iconName != null && iconName.isNotEmpty) {
      final iconData = _iconMap[iconName];
      if (iconData != null) return iconData;
    }
    return _defaultIcons[index % _defaultIcons.length];
  }

  Color _getCategoryColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) return AppColors.primary;
    try {
      final hex = colorHex.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(ArabicStrings.categories, style: AppTextStyles.titleLarge),
                if (showViewAll)
                  TextButton(
                    onPressed: onViewAllTap ?? () => Navigator.pushNamed(context, RoutesConfig.categories),
                    child: Text(
                      ArabicStrings.viewAll,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                    ),
                  ),
              ],
            ),
          ),
        if (showTitle) const SizedBox(height: 8),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final category = categories[index];
              final icon = _getCategoryIcon(category.icon, index);
              final color = _getCategoryColor(category.color);
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  RoutesConfig.categoryAds,
                  arguments: category,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 72,
                      child: Text(
                        category.name,
                        style: AppTextStyles.bodySmall,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

const Map<String, IconData> _iconMap = {
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
  'babies': Icons.child_care_rounded,
  'food': Icons.restaurant_rounded,
  'agriculture': Icons.agriculture_rounded,
  'industrial': Icons.factory_rounded,
};
