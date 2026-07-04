import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class EditAdPage extends StatefulWidget {
  final String adId;

  const EditAdPage({super.key, required this.adId});

  @override
  State<EditAdPage> createState() => _EditAdPageState();
}

class _EditAdPageState extends State<EditAdPage> {
  final _titleController = TextEditingController(text: 'عنوان الإعلان');
  final _descriptionController = TextEditingController(text: 'وصف الإعلان');
  final _priceController = TextEditingController(text: '150000');
  final _cityController = TextEditingController(text: 'دمشق');
  final _contactController = TextEditingController(text: '0999999999');
  final _formKey = GlobalKey<FormState>();

  String? _selectedCategory = 'عقارات';
  String? _selectedCurrency = 'SYP';
  String? _selectedGovernorate = 'دمشق';
  bool _isNew = true;
  bool _isNegotiable = true;
  bool _showNumber = true;
  bool _isSubmitting = false;

  final List<dynamic> _existingImages = ['url1', 'url2'];
  final List<File> _newImages = [];
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = ['عقارات', 'سيارات', 'إلكترونيات', 'أثاث', 'ملابس', 'خدمات', 'حيوانات', 'وظائف'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _cityController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final remaining = AppConfig.maxAdImages - (_existingImages.length + _newImages.length);
    if (remaining <= 0) {
      CustomSnackbar.showWarning(context, ArabicStrings.maxImagesReached);
      return;
    }
    final xFiles = await _picker.pickMultiImage(imageQuality: 85, limit: remaining);
    setState(() => _newImages.addAll(xFiles.map((x) => File(x.path))));
  }

  void _removeExisting(int index) {
    setState(() => _existingImages.removeAt(index));
  }

  void _removeNew(int index) {
    setState(() => _newImages.removeAt(index));
  }

  void _updateAd() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _isSubmitting = false);
        CustomSnackbar.showSuccess(context, 'تم تحديث الإعلان بنجاح');
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ArabicStrings.editAd)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ArabicStrings.uploadImages, style: AppTextStyles.titleLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._existingImages.map((url) => Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.shimmerBase,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(url.toString(), fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(top: -4, right: -4, child: _removeBtn(() => _removeExisting(_existingImages.indexOf(url)))),
                    ],
                  )),
                  ..._newImages.map((file) => Stack(
                    children: [
                      Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(top: -4, right: -4, child: _removeBtn(() => _removeNew(_newImages.indexOf(file)))),
                    ],
                  )),
                  if (_existingImages.length + _newImages.length < AppConfig.maxAdImages)
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_photo_alternate_rounded, size: 32, color: AppColors.textHint),
                            Text(ArabicStrings.addImage, style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              CustomTextField(controller: _titleController, label: ArabicStrings.adTitle, hint: ArabicStrings.adTitleHint, validator: AppValidators.validateAdTitle),
              const SizedBox(height: 16),
              CustomTextField(controller: _descriptionController, label: ArabicStrings.adDescription, hint: ArabicStrings.adDescriptionHint, maxLines: 5, validator: AppValidators.validateDescription),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: ArabicStrings.selectCategory),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
              ),
              const SizedBox(height: 16),
              Directionality(textDirection: TextDirection.ltr, child: CustomTextField(controller: _priceController, label: ArabicStrings.adPrice, hint: ArabicStrings.priceHint, keyboardType: TextInputType.number, validator: AppValidators.validatePrice)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCurrency,
                decoration: const InputDecoration(labelText: ArabicStrings.selectCurrency),
                items: AppConfig.currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCurrency = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _isNew ? 'new' : 'used',
                decoration: const InputDecoration(labelText: ArabicStrings.selectCondition),
                items: const [
                  DropdownMenuItem(value: 'new', child: Text(ArabicStrings.newItem)),
                  DropdownMenuItem(value: 'used', child: Text(ArabicStrings.used)),
                ],
                onChanged: (v) => setState(() => _isNew = v == 'new'),
              ),
              SwitchListTile(title: Text(ArabicStrings.negotiable), value: _isNegotiable, onChanged: (v) => setState(() => _isNegotiable = v), contentPadding: EdgeInsets.zero),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGovernorate,
                decoration: const InputDecoration(labelText: ArabicStrings.selectGovernorate),
                items: AppConfig.governorates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (v) => setState(() => _selectedGovernorate = v),
              ),
              const SizedBox(height: 16),
              CustomTextField(controller: _cityController, label: ArabicStrings.city, hint: ArabicStrings.selectCity),
              const SizedBox(height: 16),
              Directionality(textDirection: TextDirection.ltr, child: CustomTextField(controller: _contactController, label: ArabicStrings.contactNumber, hint: ArabicStrings.syrianPhoneHint, keyboardType: TextInputType.phone, prefixIcon: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), child: Text(AppConfig.defaultCountryCode, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600))))),
              SwitchListTile(title: Text(ArabicStrings.showNumber), value: _showNumber, onChanged: (v) => setState(() => _showNumber = v), contentPadding: EdgeInsets.zero),
              const SizedBox(height: 32),
              CustomButton(text: ArabicStrings.save, isLoading: _isSubmitting, onPressed: _updateAd),
            ],
          ),
        ),
      ),
    );
  }

  Widget _removeBtn(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
        child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
      ),
    );
  }
}
