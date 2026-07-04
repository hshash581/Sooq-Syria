import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/shimmer_widget.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({super.key});

  @override
  State<MyAdsPage> createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ArabicStrings.myAds, style: AppTextStyles.titleLarge),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: ArabicStrings.active),
            Tab(text: ArabicStrings.pendingAds),
            Tab(text: ArabicStrings.rejectedAds),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAdsList('active'),
          _buildAdsList('pending'),
          _buildAdsList('rejected'),
        ],
      ),
    );
  }

  Widget _buildAdsList(String status) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => _buildAdCard(status, index),
    );
  }

  Widget _buildAdCard(String status, int index) {
    final Color statusColor = status == 'active' ? AppColors.success : status == 'pending' ? AppColors.warning : AppColors.error;
    final String statusText = status == 'active' ? ArabicStrings.active : status == 'pending' ? ArabicStrings.pendingAds : ArabicStrings.rejectedAds;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image_rounded, color: AppColors.textHint),
            ),
            title: Text('إعلان رقم $index', style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(Helpers.formatPrice(150000), style: AppTextStyles.priceSmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(statusText, style: AppTextStyles.caption.copyWith(color: statusColor)),
                    ),
                    const SizedBox(width: 8),
                    Text(Helpers.formatDate(DateTime.now().subtract(Duration(days: index))), style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) => _handleAction(value, index, status),
              itemBuilder: (context) => _buildMenuItems(status),
            ),
          ),
        ],
      ),
    );
  }

  List<PopupMenuItem<String>> _buildMenuItems(String status) {
    final items = <PopupMenuItem<String>>[];
    items.add(const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_rounded, size: 18), SizedBox(width: 8), Text(ArabicStrings.edit)])));
    items.add(const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_rounded, size: 18), SizedBox(width: 8), Text(ArabicStrings.delete)])));
    if (status == 'active') {
      items.add(const PopupMenuItem(value: 'stop', child: Row(children: [Icon(Icons.pause_rounded, size: 18), SizedBox(width: 8), Text(ArabicStrings.stopAd)])));
    } else if (status == 'rejected') {
      items.add(const PopupMenuItem(value: 'renew', child: Row(children: [Icon(Icons.refresh_rounded, size: 18), SizedBox(width: 8), Text(ArabicStrings.renewAd)])));
    }
    return items;
  }

  void _handleAction(String action, int index, String status) {
    switch (action) {
      case 'edit':
        Navigator.pushNamed(context, RoutesConfig.editAd.replaceAll(':id', '$index'));
        break;
      case 'delete':
        CustomDialog.showConfirmDialog(
          context,
          title: ArabicStrings.deleteAd,
          message: 'هل أنت متأكد من حذف هذا الإعلان؟',
          isDestructive: true,
        ).then((confirmed) {
          if (confirmed == true) {
            CustomSnackbar.showSuccess(context, 'تم حذف الإعلان');
          }
        });
        break;
      case 'stop':
        CustomSnackbar.showSuccess(context, 'تم إيقاف الإعلان');
        break;
      case 'renew':
        CustomSnackbar.showSuccess(context, 'تم تجديد الإعلان');
        break;
    }
  }
}
