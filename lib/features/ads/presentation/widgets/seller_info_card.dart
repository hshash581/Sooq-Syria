import 'package:flutter/material.dart' hide DateUtils;
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/date_utils.dart';

class SellerInfoCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double rating;
  final int adsCount;
  final DateTime? joinDate;
  final bool isVerified;
  final VoidCallback? onTap;
  final VoidCallback? onChatTap;

  const SellerInfoCard({
    super.key,
    required this.name,
    this.imageUrl,
    required this.rating,
    required this.adsCount,
    this.joinDate,
    this.isVerified = false,
    this.onTap,
    this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ArabicStrings.sellerInfo, style: AppTextStyles.titleLarge),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.shimmerBase,
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: imageUrl!,
                              fit: BoxFit.cover,
                              width: 56,
                              height: 56,
                              placeholder: (_, __) => Container(
                                color: AppColors.shimmerBase,
                                child: Icon(Icons.person_rounded, size: 28, color: AppColors.textHint),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color: AppColors.shimmerBase,
                                child: Text(
                                  Helpers.getInitials(name),
                                  style: AppTextStyles.titleLarge,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            Helpers.getInitials(name),
                            style: AppTextStyles.titleLarge,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                name,
                                style: AppTextStyles.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isVerified) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.verified_rounded, size: 16, color: AppColors.primary),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: AppColors.rating),
                            const SizedBox(width: 4),
                            Text(
                              rating.toStringAsFixed(1),
                              style: AppTextStyles.bodySmall,
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.post_add_rounded, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              '$adsCount ${ArabicStrings.ads}',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        if (joinDate != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${ArabicStrings.joinDate}: ${DateUtils.formatDate(joinDate!)}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (onChatTap != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onChatTap,
                    icon: const Icon(Icons.chat_rounded, size: 18),
                    label: Text(ArabicStrings.message),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
