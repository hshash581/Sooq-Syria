import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<Map<String, dynamic>> _favorites = List.generate(
    8,
    (i) => {
      'id': i.toString(),
      'title': 'إعلان مفضل رقم $i',
      'price': 100000 + i * 5000,
      'image': null,
      'location': 'دمشق',
      'date': DateTime.now().subtract(Duration(days: i)),
    },
  );

  void _removeFavorite(int index) {
    setState(() => _favorites.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    if (_favorites.isEmpty) {
      return const Scaffold(
        body: EmptyStateWidget(
          icon: Icons.favorite_outline_rounded,
          message: ArabicStrings.noFavorites,
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: ArabicStrings.favorites,
        showBack: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _favorites.length,
          itemBuilder: (context, index) {
            final ad = _favorites[index];
            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, RoutesConfig.adDetail.replaceAll(':id', ad['id'] as String)),
              onLongPress: () => _removeFavorite(index),
              child: Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 120,
                          color: AppColors.shimmerBase,
                          child: Center(
                            child: Icon(Icons.image_rounded, size: 40, color: AppColors.textHint),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          left: 4,
                          child: GestureDetector(
                            onTap: () => _removeFavorite(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.4),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ad['title'] as String, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                            const Spacer(),
                            Text(Helpers.formatPrice((ad['price'] as num).toDouble()), style: AppTextStyles.priceSmall),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded, size: 12, color: AppColors.textHint),
                                const SizedBox(width: 4),
                                Expanded(child: Text(ad['location'] as String, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
