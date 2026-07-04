import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/date_utils.dart' as app_date_utils;

class SearchResultCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final double price;
  final String? currency;
  final String location;
  final DateTime date;
  final bool isFeatured;
  final bool isNegotiable;
  final String? condition;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const SearchResultCard({
    super.key,
    this.imageUrl,
    required this.title,
    this.description = '',
    required this.price,
    this.currency,
    required this.location,
    required this.date,
    this.isFeatured = false,
    this.isNegotiable = false,
    this.condition,
    required this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: AppColors.shimmerBase,
                            child: const Icon(Icons.image_rounded, size: 32, color: AppColors.textHint),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.shimmerBase,
                            child: const Icon(Icons.broken_image_rounded, size: 32, color: AppColors.textHint),
                          ),
                        )
                      : Container(
                          color: AppColors.shimmerBase,
                          child: const Icon(Icons.image_rounded, size: 32, color: AppColors.textHint),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (onFavoriteTap != null)
                          GestureDetector(
                            onTap: onFavoriteTap,
                            child: Icon(
                              isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              size: 20,
                              color: isFavorite ? AppColors.error : AppColors.textHint,
                            ),
                          ),
                      ],
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            Helpers.formatPrice(price, currency: currency ?? 'SYP'),
                            style: AppTextStyles.priceSmall,
                          ),
                        ),
                        if (condition != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              condition!,
                              style: AppTextStyles.overline.copyWith(color: AppColors.success),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
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
                        const SizedBox(width: 8),
                        Text(
                          app_date_utils.DateUtils.timeAgo(date),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
