import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Helpers {
  static String formatPrice(double price, {String currency = 'SYP'}) {
    final formatter = NumberFormat('#,##0', 'ar');
    return '${formatter.format(price)} $currency';
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
    if (diff.inDays < 30) return 'منذ ${(diff.inDays / 7).floor()} أسبوع';
    if (diff.inDays < 365) return 'منذ ${(diff.inDays / 30).floor()} شهر';

    final formatter = DateFormat('d MMMM yyyy', 'ar');
    return formatter.format(date);
  }

  static String formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)} ألف';
    return '${(count / 1000000).toStringAsFixed(1)} مليون';
  }

  static String formatPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.startsWith('+963')) {
      return cleaned.replaceFirst('+963', '0');
    }
    if (cleaned.startsWith('00963')) {
      return cleaned.replaceFirst('00963', '0');
    }
    return cleaned;
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> openWhatsApp(String phoneNumber, {String? message}) async {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final url = 'https://wa.me/$cleaned${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> shareApp() async {
    final url = 'https://sooqsyr.app';
    await openUrl(url);
  }

  static Future<void> rateApp() async {
    // Open app store link
    final url = 'https://play.google.com/store/apps/details?id=com.sooqsyr.app';
    await openUrl(url);
  }

  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  static String getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return parts[0][0];
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String generateAdId() {
    final now = DateTime.now();
    return 'AD${now.millisecondsSinceEpoch}${now.microsecond}';
  }
}
