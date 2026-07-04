import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/shimmer_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _bannerImages = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: false,
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.store_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            Text(ArabicStrings.appName, style: AppTextStyles.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () => Navigator.pushNamed(context, RoutesConfig.notifications),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildBannerCarousel(),
              const SizedBox(height: 24),
              _buildCategoriesSection(),
              const SizedBox(height: 16),
              _buildSectionHeader(ArabicStrings.latestAds),
              const SizedBox(height: 8),
              _buildAdsList(6),
              const SizedBox(height: 8),
              _buildSectionHeader(ArabicStrings.featuredAds, isFeatured: true),
              const SizedBox(height: 8),
              _buildAdsList(4),
              const SizedBox(height: 8),
              _buildSectionHeader(ArabicStrings.mostViewed),
              const SizedBox(height: 8),
              _buildAdsList(4),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, RoutesConfig.createAd),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.pushNamed(context, RoutesConfig.search),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.textHint),
                const SizedBox(width: 12),
                Text(
                  ArabicStrings.searchHint,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    if (_bannerImages.isEmpty) {
      return Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: Center(
          child: Text(
            ArabicStrings.appName,
            style: AppTextStyles.displaySmall.copyWith(color: Colors.white),
          ),
        ),
      );
    }
    return CarouselSlider(
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        enlargeCenterPage: true,
        viewportFraction: 0.92,
      ),
      items: _bannerImages.map((url) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(url, fit: BoxFit.cover, width: double.infinity),
      )).toList(),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = ['عقارات', 'سيارات', 'إلكترونيات', 'أثاث', 'ملابس', 'خدمات', 'حيوانات', 'وظائف'];
    final icons = [
      Icons.home_work_rounded, Icons.directions_car_rounded, Icons.devices_rounded,
      Icons.chair_rounded, Icons.checkroom_rounded, Icons.build_rounded,
      Icons.pets_rounded, Icons.work_rounded,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ArabicStrings.categories, style: AppTextStyles.titleLarge),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, RoutesConfig.categories),
                child: Text(ArabicStrings.viewAll, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => Navigator.pushNamed(context, RoutesConfig.categoryAds, arguments: categories[index]),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icons[index], color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 72,
                    child: Text(
                      categories[index],
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {bool isFeatured = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isFeatured)
                const Icon(Icons.star_rounded, color: AppColors.accent, size: 20),
              if (isFeatured) const SizedBox(width: 6),
              Text(title, style: AppTextStyles.titleLarge),
            ],
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, RoutesConfig.search, arguments: {'title': title}),
            child: Text(ArabicStrings.viewAll, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildAdsList(int count) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _AdCard(
          title: 'إعلان رقم $index',
          price: 150000 + index * 5000,
          image: null,
          location: 'دمشق',
          date: DateTime.now().subtract(Duration(hours: index)),
          onTap: () => Navigator.pushNamed(context, '/ad/$index'),
        ),
      ),
    );
  }
}

class _AdCard extends StatelessWidget {
  final String title;
  final double price;
  final String? image;
  final String location;
  final DateTime date;
  final VoidCallback onTap;

  const _AdCard({
    required this.title,
    required this.price,
    this.image,
    required this.location,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: image != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(image!, fit: BoxFit.cover, width: double.infinity),
                    )
                  : Center(
                      child: Icon(Icons.image_rounded, size: 40, color: AppColors.textHint),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      Helpers.formatPrice(price),
                      style: AppTextStyles.priceSmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 12, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: AppTextStyles.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(Helpers.formatDate(date), style: AppTextStyles.caption),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
