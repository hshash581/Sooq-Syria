import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/date_utils.dart' as app_date_utils;
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class ReportsManagementPage extends StatefulWidget {
  const ReportsManagementPage({super.key});

  @override
  State<ReportsManagementPage> createState() => _ReportsManagementPageState();
}

class _ReportsManagementPageState extends State<ReportsManagementPage> {
  final List<Map<String, dynamic>> _reports = List.generate(
    4,
    (i) => {
      'id': i.toString(),
      'reporterName': 'مبلغ ${i + 1}',
      'adId': 'AD${1000 + i}',
      'reason': i == 0 ? ArabicStrings.spam : i == 1 ? ArabicStrings.fake : ArabicStrings.inappropriate,
      'description': 'هذا وصف للبلاغ رقم ${i + 1} يشرح سبب الإبلاغ',
      'status': 'pending',
      'createdAt': DateTime.now().subtract(Duration(days: i)),
    },
  );

  void _markAsResolved(int index) {
    setState(() => _reports.removeAt(index));
    CustomSnackbar.showSuccess(context, 'تم حل البلاغ');
  }

  @override
  Widget build(BuildContext context) {
    if (_reports.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(title: ArabicStrings.totalReports),
        body: const EmptyStateWidget(
          icon: Icons.shield_rounded,
          message: 'لا توجد بلاغات',
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(title: ArabicStrings.totalReports),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.flag_rounded, color: AppColors.error, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(report['reason'] as String, style: AppTextStyles.titleMedium),
                            const SizedBox(height: 2),
                            Text('${report['reporterName']} - إعلان ${report['adId']}', style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(report['description'] as String, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 8),
                  Text(app_date_utils.DateUtils.timeAgo(report['createdAt'] as DateTime), style: AppTextStyles.caption),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _markAsResolved(index),
                        icon: const Icon(Icons.check_circle_rounded, size: 18),
                        label: Text('تم الحل', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success)),
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
