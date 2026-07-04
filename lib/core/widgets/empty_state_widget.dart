import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;
  final String? lottieAsset;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon,
    this.lottieAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (lottieAsset != null)
              SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  lottieAsset!,
                  width: 200,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    icon ?? Icons.inbox_outlined,
                    size: 80,
                    color: AppColors.textHint,
                  ),
                ),
              )
            else
              Icon(
                icon ?? Icons.inbox_outlined,
                size: 80,
                color: AppColors.textHint,
              ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
