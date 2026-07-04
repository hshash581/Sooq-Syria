import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/helpers.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String? phone;
  final String? location;
  final String? avatarUrl;
  final String? coverUrl;
  final bool isVerified;
  final VoidCallback? onEditTap;

  const ProfileHeader({
    super.key,
    required this.name,
    this.phone,
    this.location,
    this.avatarUrl,
    this.coverUrl,
    this.isVerified = false,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary,
            image: coverUrl != null
                ? DecorationImage(
                    image: CachedNetworkImageProvider(coverUrl!),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  )
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: AppColors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.shimmerBase,
                      backgroundImage: avatarUrl != null
                          ? CachedNetworkImageProvider(avatarUrl!)
                          : null,
                      child: avatarUrl == null
                          ? Text(
                              Helpers.getInitials(name),
                              style: AppTextStyles.displaySmall,
                            )
                          : null,
                    ),
                  ),
                  GestureDetector(
                    onTap: onEditTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  if (isVerified) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.verified_rounded, size: 20, color: AppColors.primary),
                  ],
                ],
              ),
              if (phone != null) ...[
                const SizedBox(height: 4),
                Text(
                  phone!,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  textDirection: TextDirection.ltr,
                ),
              ],
              if (location != null) ...[
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      location!,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
