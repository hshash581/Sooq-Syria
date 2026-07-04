import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import '../../../../core/widgets/custom_app_bar.dart';

class ChatDetailPage extends StatefulWidget {
  final String chatId;

  const ChatDetailPage({super.key, required this.chatId});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _isTyping = false;

  final List<Map<String, dynamic>> _messages = List.generate(
    10,
    (i) => {
      'id': i.toString(),
      'text': 'هذه رسالة رقم ${i + 1} في المحادثة',
      'isMe': i.isEven,
      'time': DateTime.now().subtract(Duration(minutes: (10 - i) * 5)),
      'type': 'text',
    },
  );

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': text,
        'isMe': true,
        'time': DateTime.now(),
        'type': 'text',
      });
      _messageController.clear();
    });
    Future.delayed(const Duration(milliseconds: 500), () => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _pickImage() async {
    final xFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1024, maxHeight: 1024);
    if (xFile == null) return;
    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': '',
        'isMe': true,
        'time': DateTime.now(),
        'type': 'image',
        'imageFile': File(xFile.path),
      });
    });
    Future.delayed(const Duration(milliseconds: 500), () => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.shimmerBase,
              child: Text('م', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('مستخدم', style: AppTextStyles.titleMedium),
                Text(
                  _isTyping ? ArabicStrings.typing : ArabicStrings.online,
                  style: AppTextStyles.caption.copyWith(
                    color: _isTyping ? AppColors.primary : AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['isMe'] as bool;
                final isImage = msg['type'] == 'image';
                final showDate = index == 0 || _shouldShowDate(index);

                return Column(
                  children: [
                    if (showDate)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          date_utils.DateUtils.formatDate(msg['time'] as DateTime),
                          style: AppTextStyles.caption,
                        ),
                      ),
                    Align(
                      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: isImage
                            ? EdgeInsets.zero
                            : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.primary : AppColors.background,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 16 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 16),
                          ),
                        ),
                        child: isImage
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: msg['imageFile'] != null
                                    ? Image.file(msg['imageFile'] as File, fit: BoxFit.cover, width: 200, height: 200)
                                    : Image.network(msg['text'] as String, fit: BoxFit.cover, width: 200, height: 200),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    msg['text'] as String,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: isMe ? Colors.white : AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        date_utils.DateUtils.formatTime(msg['time'] as DateTime),
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: isMe ? Colors.white70 : AppColors.textHint,
                                        ),
                                      ),
                                      if (isMe) ...[
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.done_all_rounded,
                                          size: 14,
                                          color: msg['id'] == _messages.last['id']
                                              ? AppColors.info
                                              : Colors.white70,
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  CircleAvatar(radius: 10, backgroundColor: AppColors.primary, child: Icon(Icons.person, size: 12, color: Colors.white)),
                  const SizedBox(width: 8),
                  Text(ArabicStrings.typing, style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                ],
              ),
            ),
          _buildInputBar(),
        ],
      ),
    );
  }

  bool _shouldShowDate(int index) {
    if (index == 0) return false;
    final current = _messages[index]['time'] as DateTime;
    final previous = _messages[index - 1]['time'] as DateTime;
    return current.day != previous.day || current.month != previous.month || current.year != previous.year;
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
              onPressed: _pickImage,
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                textAlign: TextAlign.right,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: ArabicStrings.typeMessage,
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onChanged: (v) {
                  final typing = v.isNotEmpty;
                  if (_isTyping != typing) setState(() => _isTyping = typing);
                },
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary,
              child: IconButton(
                icon: const Icon(Icons.send_rounded, size: 20, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
