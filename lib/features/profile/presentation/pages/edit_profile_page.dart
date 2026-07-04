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

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'محمد أحمد');
  final _bioController = TextEditingController(text: 'مهتم بشراء وبيع كل شيء');
  final _phoneController = TextEditingController(text: '0999999999');
  final _cityController = TextEditingController(text: 'دمشق');
  final _addressController = TextEditingController(text: 'شارع النصر');
  String? _selectedGovernorate = 'دمشق';
  File? _profileImage;
  bool _isSaving = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
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
              Text(ArabicStrings.profileImage, style: AppTextStyles.headlineSmall),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOption(Icons.camera_alt_rounded, ArabicStrings.camera, ImageSource.camera),
                  _buildImageOption(Icons.photo_library_rounded, ArabicStrings.gallery, ImageSource.gallery),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null) return;
    final xFile = await _picker.pickImage(source: source, maxWidth: 512, maxHeight: 512, imageQuality: 80);
    if (xFile != null) {
      setState(() => _profileImage = File(xFile.path));
    }
  }

  Widget _buildImageOption(IconData icon, String label, ImageSource source) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, source),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
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

  void _save() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() => _isSaving = false);
        CustomSnackbar.showSuccess(context, ArabicStrings.success);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ArabicStrings.edit)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: AppColors.shimmerBase,
                        backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? Text(
                                'م',
                                style: AppTextStyles.displayMedium.copyWith(color: AppColors.textSecondary),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt_rounded, size: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(controller: _nameController, label: ArabicStrings.fullName, hint: ArabicStrings.nameHint, validator: AppValidators.validateName),
                const SizedBox(height: 16),
                CustomTextField(controller: _bioController, label: ArabicStrings.bio, hint: ArabicStrings.descriptionHint, maxLines: 3),
                const SizedBox(height: 16),
                Directionality(textDirection: TextDirection.ltr, child: CustomTextField(controller: _phoneController, label: ArabicStrings.phoneNumber, hint: ArabicStrings.phoneHint, keyboardType: TextInputType.phone, prefixIcon: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), child: Text(AppConfig.defaultCountryCode, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600))))),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedGovernorate,
                  decoration: const InputDecoration(labelText: ArabicStrings.governorate),
                  items: AppConfig.governorates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (v) => setState(() => _selectedGovernorate = v),
                ),
                const SizedBox(height: 16),
                CustomTextField(controller: _cityController, label: ArabicStrings.city, hint: ArabicStrings.selectCity),
                const SizedBox(height: 16),
                CustomTextField(controller: _addressController, label: ArabicStrings.address, hint: ArabicStrings.selectLocation),
                const SizedBox(height: 32),
                CustomButton(text: ArabicStrings.save, isLoading: _isSaving, onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
