import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';

class AdDetailPage extends StatefulWidget {
  final String adId;

  const AdDetailPage({super.key, required this.adId});

  @override
  State<AdDetailPage> createState() => _AdDetailPageState();
}

class _AdDetailPageState extends State<AdDetailPage> {
  int _currentImageIndex = 0;
  bool _isFavorite = false;
  bool _showContact = false;

  final List<String> _images = [];
  final String _title = 'عنوان الإعلان';
  final String _description = 'وصف الإعلان';
  final double _price = 150000;
  final String _currency = 'SYP';
  final bool _isNegotiable = true;
  final String _governorate = 'دمشق';
  final String _city = 'دمشق';
  final String _contactNumber = '0999999999';
  final String _sellerName = 'محمد أحمد';
  final String? _sellerImage = null;
  final double _sellerRating = 4.5;
  final int _sellerAdsCount = 12;
  final DateTime _createdAt = DateTime.now().subtract(const Duration(days: 2));
  final int _viewsCount = 350;
  final int _likesCount = 24;
  final bool _isNew = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: ArabicStrings.adTitle,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
              color: _isFavorite ? AppColors.error : null,
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.flag_rounded),
            onPressed: () => Navigator.pushNamed(
              context, '/report/${widget.adId}'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSlider(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                _title,
                                style: AppTextStyles.headlineMedium,
                              ),
                            ),
                            if (_isNew)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  ArabicStrings.newItem,
                                  style: AppTextStyles.caption.copyWith(color: AppColors.success),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              Helpers.formatPrice(_price, currency: _currency),
                              style: AppTextStyles.price,
                            ),
                            if (_isNegotiable) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  ArabicStrings.negotiable,
                                  style: AppTextStyles.caption.copyWith(color: AppColors.accent),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text('$_governorate، $_city', style: AppTextStyles.bodyMedium),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text('${date_utils.DateUtils.timeAgo(_createdAt)} - ${Helpers.formatCount(_viewsCount)} ${ArabicStrings.views}', style: AppTextStyles.bodyMedium),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.favorite_rounded, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text('${Helpers.formatCount(_likesCount)} ${ArabicStrings.likes}', style: AppTextStyles.bodyMedium),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(ArabicStrings.adDescription, style: AppTextStyles.titleLarge),
                        const SizedBox(height: 8),
                        Text(_description, style: AppTextStyles.bodyLarge),
                        const SizedBox(height: 24),
                        _buildSellerCard(),
                        const SizedBox(height: 24),
                        Text(ArabicStrings.location, style: AppTextStyles.titleLarge),
                        const SizedBox(height: 8),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.map_rounded, size: 48, color: AppColors.textHint),
                                const SizedBox(height: 8),
                                Text(
                                  ArabicStrings.selectLocation,
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1,
            enableInfiniteScroll: _images.length > 1,
            onPageChanged: (index, _) => setState(() => _currentImageIndex = index),
          ),
          items: _images.isEmpty
              ? [
                  Container(
                    color: AppColors.shimmerBase,
                    child: Center(
                      child: Icon(Icons.image_rounded, size: 80, color: AppColors.textHint),
                    ),
                  ),
                ]
              : _images.map((url) => GestureDetector(
                  onTap: () => _showFullScreenImage(url),
                  child: Image.network(url, fit: BoxFit.cover, width: double.infinity),
                )).toList(),
        ),
        if (_images.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _images.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                width: _currentImageIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentImageIndex == index ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showFullScreenImage(String url) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: InteractiveViewer(
            child: Image.network(url, fit: BoxFit.contain),
          ),
        ),
      ),
    ));
  }

  Widget _buildSellerCard() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ArabicStrings.sellerInfo, style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.shimmerBase,
                  backgroundImage: _sellerImage != null ? NetworkImage(_sellerImage!) : null,
                  child: _sellerImage == null
                      ? Text(
                          Helpers.getInitials(_sellerName),
                          style: AppTextStyles.titleLarge,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_sellerName, style: AppTextStyles.titleMedium),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: AppColors.rating),
                          const SizedBox(width: 4),
                          Text('$_sellerRating', style: AppTextStyles.bodySmall),
                          const SizedBox(width: 12),
                          Text(
                            '${_sellerAdsCount} ${ArabicStrings.ads}',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_showContact)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Text(
                      '$_contactNumber',
                      style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary),
                      textDirection: TextDirection.ltr,
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                  ],
                ),
              ),
            Row(
              children: [
                if (!_showContact)
                  Expanded(
                    child: CustomButton(
                      text: ArabicStrings.showNumber,
                      isOutlined: true,
                      onPressed: () => setState(() => _showContact = true),
                    ),
                  ),
                if (_showContact) ...[
                  Expanded(
                    child: CustomButton(
                      text: ArabicStrings.call,
                      icon: Icons.phone_rounded,
                      onPressed: () => Helpers.makePhoneCall(_contactNumber),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      text: ArabicStrings.whatsapp,
                      icon: Icons.chat_rounded,
                      color: AppColors.whatsapp,
                      onPressed: () => Helpers.openWhatsApp(_contactNumber),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: ArabicStrings.message,
                    icon: Icons.email_rounded,
                    isOutlined: !_showContact,
                    onPressed: () => Navigator.pushNamed(
                      context, '/chat/${widget.adId}'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
