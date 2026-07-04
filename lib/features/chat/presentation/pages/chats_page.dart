import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';
import '../../../../core/utils/date_utils.dart' as app_date_utils;
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final List<Map<String, dynamic>> _chats = List.generate(
    5,
    (i) => {
      'id': i.toString(),
      'adTitle': 'إعلان رقم $i',
      'adImage': null,
      'userName': 'مستخدم ${i + 1}',
      'userImage': null,
      'lastMessage': 'آخر رسالة في المحادثة رقم $i',
      'lastMessageTime': DateTime.now().subtract(Duration(hours: i * 3)),
      'isUnread': i == 0,
    },
  );

  @override
  Widget build(BuildContext context) {
    if (_chats.isEmpty) {
      return const Scaffold(
        body: EmptyStateWidget(
          icon: Icons.chat_bubble_outline_rounded,
          message: ArabicStrings.noChats,
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: ArabicStrings.chats,
        showBack: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _chats.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 80),
        itemBuilder: (context, index) {
          final chat = _chats[index];
          final isUnread = chat['isUnread'] as bool;
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.shimmerBase,
                  backgroundImage: chat['userImage'] != null ? NetworkImage(chat['userImage'] as String) : null,
                  child: chat['userImage'] == null
                      ? Text(
                          (chat['userName'] as String)[0],
                          style: AppTextStyles.titleLarge.copyWith(color: AppColors.textSecondary),
                        )
                      : null,
                ),
                if (isUnread)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.badge,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    chat['userName'] as String,
                    style: isUnread
                        ? AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)
                        : AppTextStyles.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  app_date_utils.DateUtils.formatTime(chat['lastMessageTime'] as DateTime),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(
                    chat['lastMessage'] as String,
                    style: isUnread
                        ? AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)
                        : AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isUnread)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.badge,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('1', style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                  ),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            onTap: () => Navigator.pushNamed(
              context, RoutesConfig.chatDetail.replaceAll(':id', chat['id'] as String)),
          );
        },
      ),
    );
  }
}
