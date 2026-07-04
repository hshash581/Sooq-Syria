import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/shimmer_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class CategoryAdsPage extends StatefulWidget {
  final String categoryName;

  const CategoryAdsPage({super.key, required this.categoryName});

  @override
  State<CategoryAdsPage> createState() => _CategoryAdsPageState();
}

class _CategoryAdsPageState extends State<CategoryAdsPage> {
  bool _isLoading = false;
  late final List<Map<String, dynamic>> _ads;

  @override
  void initState() {
    super.initState();
    _ads = List.generate(
      6,
      (i) => {
        'id': i.toString(),
        'title': '${widget.categoryName} - إعلان ${i + 1}',
        'price': 80000 + i * 10000,
        'location': 'دمشق',
        'date': DateTime.now().subtract(Duration(hours: i * 3)),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.categoryName,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => Navigator.pushNamed(context, RoutesConfig.searchFilters),
          ),
        ],
      ),
      body: _isLoading
          ? const Padding(padding: EdgeInsets.all(16), child: ListShimmer())
          : _ads.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.category_outlined,
                  message: ArabicStrings.noAds,
                )
              : RefreshIndicator(
                  onRefresh: () async {},
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _ads.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final ad = _ads[index];
                      return Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          leading: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.shimmerBase,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.image_rounded, color: AppColors.textHint),
                          ),
                          title: Text(ad['title'] as String, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Helpers.formatPrice((ad['price'] as num).toDouble()), style: AppTextStyles.priceSmall),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_rounded, size: 12, color: AppColors.textHint),
                                  const SizedBox(width: 4),
                                  Text(ad['location'] as String, style: AppTextStyles.caption),
                                  const Spacer(),
                                  Text(Helpers.formatDate(ad['date'] as DateTime), style: AppTextStyles.caption),
                                ],
                              ),
                            ],
                          ),
                          onTap: () => Navigator.pushNamed(context, RoutesConfig.adDetail.replaceAll(':id', ad['id'] as String)),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
