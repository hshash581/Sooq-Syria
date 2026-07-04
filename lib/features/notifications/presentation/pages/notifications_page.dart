import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';
import '../../../../core/utils/date_utils.dart' as app_date_utils;
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, dynamic>> _notifications = List.generate(
    5,
    (i) => {
      'id': i.toString(),
      'title': 'إشعار رقم ${i + 1}',
      'body': 'هذا هو نص الإشعار رقم ${i + 1} مع وصف مختصر',
      'type': i == 0 ? 'ad' : i == 1 ? 'chat' : 'system',
      'isRead': i != 0,
      'time': DateTime.now().subtract(Duration(hours: i * 4)),
    },
  );

  void _markAsRead(int index) {
    setState(() => _notifications[index]['isRead'] = true);
  }

  void _deleteNotification(int index) {
    setState(() => _notifications.removeAt(index));
  }

  void _onTap(Map<String, dynamic> notification) {
    _markAsRead(_notifications.indexOf(notification));
    final type = notification['type'] as String;
    if (type == 'ad') {
      Navigator.pushNamed(context, RoutesConfig.adDetail.replaceAll(':id', notification['id'] as String));
    } else if (type == 'chat') {
      Navigator.pushNamed(context, RoutesConfig.chatDetail.replaceAll(':id', notification['id'] as String));
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'ad': return Icons.sell_rounded;
      case 'chat': return Icons.chat_rounded;
      case 'system': return Icons.info_rounded;
      case 'favorite': return Icons.favorite_rounded;
      default: return Icons.notifications_rounded;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'ad': return AppColors.primary;
      case 'chat': return AppColors.whatsapp;
      case 'system': return AppColors.info;
      case 'favorite': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_notifications.isEmpty) {
      return const Scaffold(
        body: EmptyStateWidget(
          icon: Icons.notifications_outlined,
          message: ArabicStrings.noNotifications,
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: ArabicStrings.notifications,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          final isRead = notification['isRead'] as bool;
          final type = notification['type'] as String;

          return Dismissible(
            key: Key(notification['id'] as String),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              color: AppColors.error,
              child: const Icon(Icons.delete_rounded, color: Colors.white),
            ),
            onDismissed: (_) => _deleteNotification(index),
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: _getTypeColor(type).withValues(alpha: 0.1),
                child: Icon(
                  _getTypeIcon(type),
                  color: _getTypeColor(type),
                  size: 24,
                ),
              ),
              title: Text(
                notification['title'] as String,
                style: isRead ? AppTextStyles.titleMedium : AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['body'] as String,
                    style: isRead
                        ? AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)
                        : AppTextStyles.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    app_date_utils.DateUtils.timeAgo(notification['time'] as DateTime),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              trailing: !isRead
                  ? GestureDetector(
                      onTap: () => _markAsRead(index),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
              onTap: () => _onTap(notification),
            ),
          );
        },
      ),
    );
  }
}
