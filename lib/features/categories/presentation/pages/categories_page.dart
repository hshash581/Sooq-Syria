import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryData('عقارات', Icons.home_work_rounded, AppColors.primary, 45),
      _CategoryData('سيارات', Icons.directions_car_rounded, AppColors.secondary, 32),
      _CategoryData('إلكترونيات', Icons.devices_rounded, AppColors.info, 28),
      _CategoryData('أثاث', Icons.chair_rounded, AppColors.warning, 18),
      _CategoryData('ملابس', Icons.checkroom_rounded, AppColors.accent, 22),
      _CategoryData('خدمات', Icons.build_rounded, AppColors.primaryLight, 15),
      _CategoryData('حيوانات', Icons.pets_rounded, AppColors.success, 8),
      _CategoryData('وظائف', Icons.work_rounded, AppColors.primaryDark, 5),
      _CategoryData('كتب', Icons.menu_book_rounded, AppColors.rating, 12),
      _CategoryData('أخرى', Icons.more_horiz_rounded, AppColors.textSecondary, 20),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: ArabicStrings.categories,
        showBack: false,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context, RoutesConfig.categoryAds.replaceAll(':id', cat.name)),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: cat.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(cat.icon, color: cat.color, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(cat.name, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${cat.adsCount} ${ArabicStrings.ads}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryData {
  final String name;
  final IconData icon;
  final Color color;
  final int adsCount;

  _CategoryData(this.name, this.icon, this.color, this.adsCount);
}
