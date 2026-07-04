import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../constants/arabic_strings.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final double size;

  const LoadingWidget({
    super.key,
    this.message,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: Lottie.asset(
              'assets/animations/loading.json',
              width: size,
              height: size,
              errorBuilder: (context, error, stackTrace) =>
                  const CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: AppColors.overlay,
            child: const LoadingWidget(message: ArabicStrings.pleaseWait),
          ),
      ],
    );
  }
}
