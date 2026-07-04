import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/date_utils.dart' as app_date_utils;

class MessageBubble extends StatelessWidget {
  final String text;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isSent;
  final bool isRead;
  final String? senderName;
  final String? senderImage;

  const MessageBubble({
    super.key,
    this.text = '',
    this.imageUrl,
    required this.createdAt,
    required this.isSent,
    this.isRead = false,
    this.senderName,
    this.senderImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isSent && senderImage != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.shimmerBase,
                    backgroundImage: senderImage!.isNotEmpty
                        ? CachedNetworkImageProvider(senderImage!)
                        : null,
                    child: senderImage == null || senderImage!.isEmpty
                        ? Icon(Icons.person_rounded, size: 14, color: AppColors.textHint)
                        : null,
                  ),
                ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSent ? AppColors.primary : AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isSent ? 16 : 4),
                      bottomRight: Radius.circular(isSent ? 4 : 16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isSent && senderName != null && senderName!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            senderName!,
                            style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                          ),
                        ),
                      if (imageUrl != null && imageUrl!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: text.isNotEmpty ? 8 : 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl!,
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                              placeholder: (_, __) => Container(
                                width: 200,
                                height: 200,
                                color: AppColors.shimmerBase,
                                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                width: 200,
                                height: 200,
                                color: AppColors.shimmerBase,
                                child: const Icon(Icons.broken_image_rounded, size: 40, color: AppColors.textHint),
                              ),
                            ),
                          ),
                        ),
                      if (text.isNotEmpty)
                        Text(
                          text,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isSent ? AppColors.white : AppColors.textPrimary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (isSent)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isRead ? Icons.done_all_rounded : Icons.check_rounded,
                        size: 14,
                        color: isRead ? AppColors.primary : AppColors.textHint,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              right: isSent ? 20 : 0,
              left: isSent ? 0 : 20,
            ),
            child: Text(
              app_date_utils.DateUtils.formatTime(createdAt),
              style: AppTextStyles.overline.copyWith(color: AppColors.textHint),
            ),
          ),
        ],
      ),
    );
  }
}
