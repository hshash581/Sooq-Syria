import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/config/routes_config.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/shimmer_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        setState(() => _results.clear());
        return;
      }
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          _results.clear();
          for (int i = 0; i < 4; i++) {
            _results.add({
              'id': i.toString(),
              'title': 'نتيجة بحث $i',
              'price': 50000 + i * 10000,
              'location': 'دمشق',
              'date': DateTime.now(),
            });
          }
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          textAlign: TextAlign.right,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: ArabicStrings.searchHint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
            border: InputBorder.none,
            filled: false,
          ),
          onChanged: _onSearchChanged,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => Navigator.pushNamed(context, RoutesConfig.searchFilters),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ListShimmer(),
      );
    }

    if (_searchController.text.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_rounded, size: 80, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(
              ArabicStrings.searchHint,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 80, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(
              ArabicStrings.noResults,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final ad = _results[index];
        return ListTile(
          leading: Container(
            width: 64,
            height: 64,
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
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, size: 12, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text(ad['location'] as String, style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
          onTap: () => Navigator.pushNamed(context, '/ad/${ad['id'] as String}'),
        );
      },
    );
  }
}
