import 'package:flutter/material.dart' hide DateUtils;
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../chat/domain/entities/chat_entity.dart';

class ChatTile extends StatelessWidget {
  final ChatEntity chat;
  final String currentUserId;
  final VoidCallback? onTap;

  const ChatTile({
    super.key,
    required this.chat,
    required this.currentUserId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSeller = currentUserId == chat.sellerId;
    final otherName = isSeller ? chat.buyerName : chat.sellerName;
    final otherImage = isSeller ? chat.buyerImage : chat.sellerImage;
    final isUnread = chat.isUnread(currentUserId);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.shimmerBase,
            child: otherImage != null && otherImage.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: otherImage,
                      fit: BoxFit.cover,
                      width: 56,
                      height: 56,
                      placeholder: (_, __) => Container(
                        color: AppColors.shimmerBase,
                        child: Icon(Icons.person_rounded, size: 28, color: AppColors.textHint),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.shimmerBase,
                        child: Icon(Icons.person_rounded, size: 28, color: AppColors.textHint),
                      ),
                    ),
                  )
                : Text(
                    Helpers.getInitials(otherName),
                    style: AppTextStyles.titleLarge,
                  ),
          ),
          if (isUnread)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.badge,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              otherName,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _formatTime(chat.lastMessageTime),
            style: AppTextStyles.caption,
          ),
        ],
      ),
      subtitle: Row(
        children: [
          if (chat.lastSenderId == currentUserId)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(
                chat.isUnread(currentUserId) ? Icons.check_rounded : Icons.done_all_rounded,
                size: 14,
                color: chat.isUnread(currentUserId) ? AppColors.textHint : AppColors.primary,
              ),
            ),
          Expanded(
            child: Text(
              chat.lastMessage,
              style: AppTextStyles.bodySmall.copyWith(
                color: isUnread ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isUnread && chat.lastMessageType != 'text')
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                chat.lastMessageType == 'image' ? Icons.image_rounded : Icons.mic_rounded,
                size: 14,
                color: AppColors.textHint,
              ),
            ),
        ],
      ),
      trailing: isUnread
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: const BoxDecoration(
                color: AppColors.badge,
                shape: BoxShape.circle,
              ),
              child: Text(
                '1',
                style: AppTextStyles.caption.copyWith(color: AppColors.white),
              ),
            )
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  String _formatTime(DateTime date) {
    if (DateUtils.isToday(date)) {
      return DateUtils.formatTime(date);
    }
    if (DateUtils.isYesterday(date)) {
      return 'أمس';
    }
    if (date.year == DateTime.now().year) {
      final months = [
        '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      return '${date.day} ${months[date.month]}';
    }
    return DateUtils.formatDate(date);
  }
}
