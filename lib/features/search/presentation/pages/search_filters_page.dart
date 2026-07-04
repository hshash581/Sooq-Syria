import 'package:flutter/material.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class SearchFiltersPage extends StatefulWidget {
  const SearchFiltersPage({super.key});

  @override
  State<SearchFiltersPage> createState() => _SearchFiltersPageState();
}

class _SearchFiltersPageState extends State<SearchFiltersPage> {
  String? _selectedCategory;
  String? _selectedGovernorate;
  String? _selectedCondition;
  String? _sortBy;
  final _priceFromController = TextEditingController();
  final _priceToController = TextEditingController();
  final _cityController = TextEditingController();

  final List<String> _categories = ['الكل', 'عقارات', 'سيارات', 'إلكترونيات', 'أثاث', 'ملابس', 'خدمات', 'حيوانات', 'وظائف'];
  final List<String> _conditions = [ArabicStrings.all, ArabicStrings.newItem, ArabicStrings.used];
  final List<String> _sortOptions = [
    ArabicStrings.newest,
    ArabicStrings.oldest,
    ArabicStrings.cheapest,
    ArabicStrings.mostExpensive,
    ArabicStrings.mostViewedFilter,
  ];

  @override
  void dispose() {
    _priceFromController.dispose();
    _priceToController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      _selectedCategory = null;
      _selectedGovernorate = null;
      _selectedCondition = null;
      _sortBy = null;
      _priceFromController.clear();
      _priceToController.clear();
      _cityController.clear();
    });
  }

  void _apply() {
    Navigator.pop(context, {
      'category': _selectedCategory,
      'governorate': _selectedGovernorate,
      'condition': _selectedCondition,
      'sortBy': _sortBy,
      'priceFrom': _priceFromController.text,
      'priceTo': _priceToController.text,
      'city': _cityController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ArabicStrings.filters),
        actions: [
          TextButton(
            onPressed: _reset,
            child: Text(ArabicStrings.delete, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ArabicStrings.adCategory, style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(hintText: ArabicStrings.selectCategory, filled: true),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
            const SizedBox(height: 24),
            Text(ArabicStrings.governorate, style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedGovernorate,
              decoration: const InputDecoration(hintText: ArabicStrings.selectGovernorate, filled: true),
              items: AppConfig.governorates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) => setState(() => _selectedGovernorate = v),
            ),
            const SizedBox(height: 16),
            CustomTextField(controller: _cityController, label: ArabicStrings.city, hint: ArabicStrings.selectCity),
            const SizedBox(height: 24),
            Text(ArabicStrings.priceRange, style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: CustomTextField(
                      controller: _priceFromController,
                      hint: ArabicStrings.from,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(ArabicStrings.to, style: AppTextStyles.bodyLarge),
                ),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: CustomTextField(
                      controller: _priceToController,
                      hint: ArabicStrings.to,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(ArabicStrings.condition, style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCondition,
              decoration: const InputDecoration(hintText: ArabicStrings.selectCondition, filled: true),
              items: _conditions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCondition = v),
            ),
            const SizedBox(height: 24),
            Text(ArabicStrings.sortBy, style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _sortBy,
              decoration: const InputDecoration(hintText: ArabicStrings.sortBy, filled: true),
              items: _sortOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _sortBy = v),
            ),
            const SizedBox(height: 32),
            CustomButton(text: ArabicStrings.submit, onPressed: _apply),
          ],
        ),
      ),
    );
  }
}
