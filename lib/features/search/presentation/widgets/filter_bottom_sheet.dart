import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../categories/domain/entities/category_entity.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<CategoryEntity> categories;
  final List<String> governorates;
  final String? selectedCategoryId;
  final String? selectedGovernorate;
  final double? minPrice;
  final double? maxPrice;
  final String? selectedCondition;
  final String? sortBy;
  final ValueChanged<FilterResult> onApply;

  const FilterBottomSheet({
    super.key,
    required this.categories,
    required this.governorates,
    this.selectedCategoryId,
    this.selectedGovernorate,
    this.minPrice,
    this.maxPrice,
    this.selectedCondition,
    this.sortBy,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String? _categoryId;
  late String? _governorate;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  late String? _condition;
  late String? _sortBy;

  final List<String> _conditions = ['الكل', 'جديد', 'مستعمل'];
  final List<String> _sortOptions = [
    ArabicStrings.newest,
    ArabicStrings.oldest,
    ArabicStrings.cheapest,
    ArabicStrings.mostExpensive,
    ArabicStrings.mostViewedFilter,
  ];

  @override
  void initState() {
    super.initState();
    _categoryId = widget.selectedCategoryId;
    _governorate = widget.selectedGovernorate;
    _minPriceController = TextEditingController(text: widget.minPrice?.toString() ?? '');
    _maxPriceController = TextEditingController(text: widget.maxPrice?.toString() ?? '');
    _condition = widget.selectedCondition;
    _sortBy = widget.sortBy;
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _apply() {
    final result = FilterResult(
      categoryId: _categoryId,
      governorate: _governorate,
      minPrice: double.tryParse(_minPriceController.text),
      maxPrice: double.tryParse(_maxPriceController.text),
      condition: _condition,
      sortBy: _sortBy,
    );
    widget.onApply(result);
    Navigator.pop(context);
  }

  void _reset() {
    setState(() {
      _categoryId = null;
      _governorate = null;
      _minPriceController.clear();
      _maxPriceController.clear();
      _condition = null;
      _sortBy = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ArabicStrings.filters, style: AppTextStyles.headlineMedium),
              TextButton(
                onPressed: _reset,
                child: Text(
                  ArabicStrings.delete,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel(ArabicStrings.adCategory),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: _categoryId,
                    hint: ArabicStrings.allCategories,
                    items: widget.categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                    onChanged: (v) => setState(() => _categoryId = v),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionLabel(ArabicStrings.governorate),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: _governorate,
                    hint: ArabicStrings.all,
                    items: widget.governorates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (v) => setState(() => _governorate = v),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionLabel(ArabicStrings.priceRange),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPriceField(
                          controller: _minPriceController,
                          hint: ArabicStrings.from,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPriceField(
                          controller: _maxPriceController,
                          hint: ArabicStrings.to,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionLabel(ArabicStrings.condition),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _conditions.map((cond) {
                      final selected = _condition == cond || (cond == 'الكل' && _condition == null);
                      return ChoiceChip(
                        label: Text(cond),
                        selected: selected,
                        onSelected: (_) => setState(() => _condition = cond == 'الكل' ? null : cond),
                        selectedColor: AppColors.primary.withOpacity(0.15),
                        labelStyle: AppTextStyles.bodyMedium.copyWith(
                          color: selected ? AppColors.primary : AppColors.textSecondary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionLabel(ArabicStrings.sortBy),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: _sortBy,
                    hint: ArabicStrings.newest,
                    items: _sortOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => setState(() => _sortBy = v),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          CustomButton(
            text: 'تطبيق',
            onPressed: _apply,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(label, style: AppTextStyles.titleMedium);
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.fieldRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint)),
          style: AppTextStyles.bodyLarge,
          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.textSecondary),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPriceField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.fieldRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.fieldRadius),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.fieldRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}

class FilterResult {
  final String? categoryId;
  final String? governorate;
  final double? minPrice;
  final double? maxPrice;
  final String? condition;
  final String? sortBy;

  const FilterResult({
    this.categoryId,
    this.governorate,
    this.minPrice,
    this.maxPrice,
    this.condition,
    this.sortBy,
  });
}
