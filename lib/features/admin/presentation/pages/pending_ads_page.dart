import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class PendingAdsPage extends StatefulWidget {
  const PendingAdsPage({super.key});

  @override
  State<PendingAdsPage> createState() => _PendingAdsPageState();
}

class _PendingAdsPageState extends State<PendingAdsPage> {
  final List<Map<String, dynamic>> _pendingAds = List.generate(
    5,
    (i) => {
      'id': i.toString(),
      'title': 'إعلان معلق رقم ${i + 1}',
      'price': 100000 + i * 5000,
      'userName': 'مستخدم ${i + 1}',
      'date': DateTime.now().subtract(Duration(days: i)),
    },
  );

  void _approveAd(int index) {
    setState(() => _pendingAds.removeAt(index));
    CustomSnackbar.showSuccess(context, 'تم قبول الإعلان');
  }

  void _rejectAd(int index) async {
    final reason = await CustomDialog.showInputDialog(
      context,
      title: 'سبب الرفض',
      hint: 'أدخل سبب الرفض',
      confirmText: ArabicStrings.reject,
      maxLines: 3,
    );
    if (reason != null && reason.trim().isNotEmpty) {
      setState(() => _pendingAds.removeAt(index));
      CustomSnackbar.showWarning(context, 'تم رفض الإعلان');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pendingAds.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(title: ArabicStrings.pendingAds),
        body: const EmptyStateWidget(
          icon: Icons.check_circle_outline_rounded,
          message: 'لا توجد إعلانات معلقة',
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(title: ArabicStrings.pendingAds),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingAds.length,
        itemBuilder: (context, index) {
          final ad = _pendingAds[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.image_rounded, color: AppColors.textHint),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ad['title'] as String, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(Helpers.formatPrice((ad['price'] as num).toDouble()), style: AppTextStyles.priceSmall),
                            const SizedBox(height: 4),
                            Text(ad['userName'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                            Text(Helpers.formatDate(ad['date'] as DateTime), style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: ArabicStrings.approve,
                          color: AppColors.success,
                          onPressed: () => _approveAd(index),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: ArabicStrings.reject,
                          color: AppColors.error,
                          onPressed: () => _rejectAd(index),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
