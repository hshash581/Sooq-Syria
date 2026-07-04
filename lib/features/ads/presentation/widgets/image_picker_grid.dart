import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';

class ImagePickerGrid extends StatelessWidget {
  final List<String> images;
  final int maxImages;
  final bool isLoading;
  final VoidCallback onAddTap;
  final ValueChanged<int> onDelete;
  final void Function(int oldIndex, int newIndex)? onReorder;

  const ImagePickerGrid({
    super.key,
    required this.images,
    this.maxImages = 8,
    this.isLoading = false,
    required this.onAddTap,
    required this.onDelete,
    this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final canAddMore = images.length < maxImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(ArabicStrings.uploadImages, style: AppTextStyles.titleLarge),
            const Spacer(),
            Text(
              '${images.length}/$maxImages',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...List.generate(images.length, (index) {
              return _ImageItem(
                key: ValueKey('image_$index'),
                path: images[index],
                index: index,
                isLoading: isLoading,
                onDelete: () => onDelete(index),
              );
            }),
            if (canAddMore)
              _AddImageButton(
                key: const ValueKey('add_button'),
                onTap: onAddTap,
              ),
          ],
        ),
      ],
    );
  }
}

class _ImageItem extends StatelessWidget {
  final String path;
  final int index;
  final bool isLoading;
  final VoidCallback onDelete;

  const _ImageItem({
    super.key,
    required this.path,
    required this.index,
    required this.isLoading,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width - 40) / 3,
            height: (MediaQuery.of(context).size.width - 40) / 3,
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.shimmerBase,
                child: const Icon(Icons.broken_image_rounded, color: AppColors.textHint),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: isLoading ? null : onDelete,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded, size: 16, color: AppColors.white),
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: AppColors.overlay,
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.overlay,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${index + 1}',
                style: AppTextStyles.caption.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddImageButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddImageButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = (MediaQuery.of(context).size.width - 40) / 3;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 4),
            Text(
              ArabicStrings.addImage,
              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
