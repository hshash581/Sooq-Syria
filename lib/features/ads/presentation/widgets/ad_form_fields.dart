import 'package:flutter/material.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../categories/domain/entities/category_entity.dart';

class AdFormFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final CategoryEntity? selectedCategory;
  final String? selectedCondition;
  final bool isNegotiable;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onConditionChanged;
  final ValueChanged<bool> onNegotiableChanged;
  final List<CategoryEntity> categories;
  final List<String> conditions;

  const AdFormFields({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
    this.selectedCategory,
    this.selectedCondition,
    required this.isNegotiable,
    required this.onCategoryChanged,
    required this.onConditionChanged,
    required this.onNegotiableChanged,
    required this.categories,
    this.conditions = const ['جديد', 'مستعمل'],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(ArabicStrings.adTitle),
        const SizedBox(height: 8),
        _buildTextField(
          controller: titleController,
          hint: ArabicStrings.adTitleHint,
        ),
        const SizedBox(height: 16),
        _buildLabel(ArabicStrings.adDescription),
        const SizedBox(height: 8),
        _buildTextField(
          controller: descriptionController,
          hint: ArabicStrings.adDescriptionHint,
          maxLines: 5,
          maxLength: 500,
        ),
        const SizedBox(height: 16),
        _buildLabel(ArabicStrings.adCategory),
        const SizedBox(height: 8),
        _buildCategorySelector(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(ArabicStrings.adPrice),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: priceController,
                    hint: ArabicStrings.priceHint,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(ArabicStrings.adCondition),
                  const SizedBox(height: 8),
                  _buildConditionSelector(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildNegotiableToggle(),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        counterText: '',
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.fieldRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.fieldRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.fieldRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory?.id,
          isExpanded: true,
          hint: Text(
            ArabicStrings.selectCategory,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
          ),
          style: AppTextStyles.bodyLarge,
          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.textSecondary),
          items: categories.map((cat) {
            return DropdownMenuItem(
              value: cat.id,
              child: Text(cat.name),
            );
          }).toList(),
          onChanged: onCategoryChanged,
        ),
      ),
    );
  }

  Widget _buildConditionSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.fieldRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCondition,
          isExpanded: true,
          hint: Text(
            ArabicStrings.selectCondition,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
          ),
          style: AppTextStyles.bodyLarge,
          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.textSecondary),
          items: conditions.map((cond) {
            return DropdownMenuItem(value: cond, child: Text(cond));
          }).toList(),
          onChanged: onConditionChanged,
        ),
      ),
    );
  }

  Widget _buildNegotiableToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.fieldRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              ArabicStrings.negotiable,
              style: AppTextStyles.bodyLarge,
            ),
          ),
          Switch(
            value: isNegotiable,
            activeThumbColor: AppColors.primary,
            onChanged: onNegotiableChanged,
          ),
        ],
      ),
    );
  }
}
