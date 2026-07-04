import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';

class ProfileImagePicker extends StatelessWidget {
  final String? imageUrl;
  final String? localImagePath;
  final double size;
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const ProfileImagePicker({
    super.key,
    this.imageUrl,
    this.localImagePath,
    this.size = 100,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              ArabicStrings.profileImage,
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
              ),
              title: Text(ArabicStrings.camera, style: AppTextStyles.bodyLarge),
              trailing: const Icon(Icons.arrow_back_ios_rounded, size: 16, color: AppColors.textHint),
              onTap: () {
                Navigator.pop(ctx);
                onCameraTap();
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.photo_library_rounded, color: AppColors.secondary),
              ),
              title: Text(ArabicStrings.gallery, style: AppTextStyles.bodyLarge),
              trailing: const Icon(Icons.arrow_back_ios_rounded, size: 16, color: AppColors.textHint),
              onTap: () {
                Navigator.pop(ctx);
                onGalleryTap();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPickerOptions(context),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.shimmerBase,
              border: Border.all(color: AppColors.border, width: 3),
            ),
            child: ClipOval(
              child: _buildImage(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              color: AppColors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (localImagePath != null) {
      return Image.file(
        File(localImagePath!),
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.shimmerBase,
      child: Icon(
        Icons.person_rounded,
        size: size * 0.5,
        color: AppColors.textHint,
      ),
    );
  }
}
