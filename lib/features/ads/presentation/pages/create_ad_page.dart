import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/routes_config.dart';
import '../../../../core/constants/arabic_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class CreateAdPage extends StatefulWidget {
  const CreateAdPage({super.key});

  @override
  State<CreateAdPage> createState() => _CreateAdPageState();
}

class _CreateAdPageState extends State<CreateAdPage> {
  final _pageController = PageController();
  int _currentStep = 0;
  bool _isSubmitting = false;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _cityController = TextEditingController();
  final _contactController = TextEditingController();
  final _formKeys = List.generate(5, (_) => GlobalKey<FormState>());

  String? _selectedCategory;
  String? _selectedCurrency;
  String? _selectedGovernorate;
  bool _isNew = true;
  bool _isNegotiable = false;
  bool _showNumber = true;

  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  double _uploadProgress = 0;

  final List<String> _categories = ['عقارات', 'سيارات', 'إلكترونيات', 'أثاث', 'ملابس', 'خدمات', 'حيوانات', 'وظائف'];

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _cityController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ArabicStrings.selectImages, style: AppTextStyles.headlineSmall),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ImageOption(
                    icon: Icons.camera_alt_rounded,
                    label: ArabicStrings.camera,
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  _ImageOption(
                    icon: Icons.photo_library_rounded,
                    label: ArabicStrings.gallery,
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null) return;
    if (source == ImageSource.camera) {
      final xFile = await _picker.pickImage(source: source, maxWidth: 1920, maxHeight: 1920);
      if (xFile != null) {
        setState(() => _selectedImages.add(File(xFile.path)));
      }
    } else {
      final remaining = AppConfig.maxAdImages - _selectedImages.length;
      if (remaining <= 0) {
        CustomSnackbar.showWarning(context, ArabicStrings.maxImagesReached);
        return;
      }
      final xFiles = await _picker.pickMultiImage(
        imageQuality: 85,
        limit: remaining,
      );
      setState(() {
        _selectedImages.addAll(xFiles.map((x) => File(x.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < 4) {
        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        setState(() => _currentStep++);
      } else {
        _submitAd();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentStep--);
    }
  }

  void _submitAd() async {
    if (!mounted) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    CustomSnackbar.showSuccess(context, 'تم نشر الإعلان بنجاح');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ArabicStrings.addAd),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildStepper(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
                _buildStep4(),
                _buildStep5(),
              ],
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: List.generate(
          5,
          (index) => Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= _currentStep ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKeys[0],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ArabicStrings.uploadImages, style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            Text(
              '${ArabicStrings.maxImagesReached} (${_selectedImages.length}/${AppConfig.maxAdImages})',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...List.generate(
                  _selectedImages.length,
                  (index) => Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(_selectedImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selectedImages.length < AppConfig.maxAdImages)
                  GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_photo_alternate_rounded, size: 32, color: AppColors.textHint),
                          const SizedBox(height: 4),
                          Text(ArabicStrings.addImage, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKeys[1],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _titleController,
              label: ArabicStrings.adTitle,
              hint: ArabicStrings.adTitleHint,
              validator: AppValidators.validateAdTitle,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              label: ArabicStrings.adDescription,
              hint: ArabicStrings.adDescriptionHint,
              maxLines: 5,
              validator: AppValidators.validateDescription,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: ArabicStrings.selectCategory),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v),
              validator: (v) => v == null ? ArabicStrings.categoryRequired : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return Form(
      key: _formKeys[2],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: CustomTextField(
                controller: _priceController,
                label: ArabicStrings.adPrice,
                hint: ArabicStrings.priceHint,
                keyboardType: TextInputType.number,
                validator: AppValidators.validatePrice,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCurrency ?? AppConfig.defaultCurrency,
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
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(ArabicStrings.negotiable),
              value: _isNegotiable,
              onChanged: (v) => setState(() => _isNegotiable = v),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep4() {
    return Form(
      key: _formKeys[3],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedGovernorate,
              decoration: const InputDecoration(labelText: ArabicStrings.selectGovernorate),
              items: AppConfig.governorates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) => setState(() => _selectedGovernorate = v),
              validator: (v) => v == null ? ArabicStrings.governorateRequired : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _cityController,
              label: ArabicStrings.city,
              hint: ArabicStrings.selectCity,
              validator: (v) => v == null || v.trim().isEmpty ? ArabicStrings.cityRequired : null,
            ),
            const SizedBox(height: 16),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.map_rounded, size: 48, color: AppColors.textHint),
                    const SizedBox(height: 8),
                    Text(ArabicStrings.selectLocation, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep5() {
    return Form(
      key: _formKeys[4],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: CustomTextField(
                controller: _contactController,
                label: ArabicStrings.contactNumber,
                hint: ArabicStrings.syrianPhoneHint,
                keyboardType: TextInputType.phone,
                validator: AppValidators.validatePhone,
                prefixIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Text(
                    AppConfig.defaultCountryCode,
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(ArabicStrings.showNumber),
              subtitle: Text(
                _showNumber ? ArabicStrings.showNumber : ArabicStrings.hideNumber,
                style: AppTextStyles.bodySmall,
              ),
              value: _showNumber,
              onChanged: (v) => setState(() => _showNumber = v),
              contentPadding: EdgeInsets.zero,
            ),
            if (_isSubmitting) ...[
              const SizedBox(height: 24),
              LinearProgressIndicator(value: _uploadProgress),
              const SizedBox(height: 8),
              Text(
                '${(_uploadProgress * 100).toInt()}%',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: CustomButton(
                  text: ArabicStrings.back,
                  isOutlined: true,
                  onPressed: _previousStep,
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: _currentStep == 4 ? ArabicStrings.submit : ArabicStrings.next,
                isLoading: _isSubmitting,
                onPressed: _nextStep,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
