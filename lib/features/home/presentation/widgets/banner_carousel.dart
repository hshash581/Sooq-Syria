import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../home/domain/entities/banner_entity.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerEntity> banners;
  final double height;
  final double viewportFraction;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final void Function(BannerEntity banner)? onBannerTap;

  const BannerCarousel({
    super.key,
    required this.banners,
    this.height = 180,
    this.viewportFraction = 0.92,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.onBannerTap,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return Container(
        height: widget.height,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          gradient: const LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: Center(
          child: Text(
            'سوق سوريا',
            style: AppTextStyles.displaySmall.copyWith(color: AppColors.white),
          ),
        ),
      );
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: widget.height,
            autoPlay: widget.autoPlay,
            autoPlayInterval: widget.autoPlayInterval,
            enlargeCenterPage: true,
            viewportFraction: widget.viewportFraction,
            onPageChanged: (index, _) => setState(() => _currentIndex = index),
          ),
          items: widget.banners.map((banner) {
            return GestureDetector(
              onTap: () => widget.onBannerTap?.call(banner),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: banner.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (_, __) => Container(
                        color: AppColors.shimmerBase,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.shimmerBase,
                        child: const Icon(Icons.broken_image_rounded, size: 48, color: AppColors.textHint),
                      ),
                    ),
                    if (banner.title != null || banner.subtitle != null)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, AppColors.overlay],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (banner.title != null)
                                Text(
                                  banner.title!,
                                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
                                ),
                              if (banner.subtitle != null)
                                Text(
                                  banner.subtitle!,
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.white.withOpacity(0.9)),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.banners.length > 1)
          const SizedBox(height: 8),
        if (widget.banners.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
