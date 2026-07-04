class AppValidators {
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    final phone = value.replaceAll(RegExp(r'\s+'), '');
    if (phone.length < 9 || phone.length > 13) {
      return 'رقم هاتف غير صالح';
    }
    return null;
  }

  static String? validateSyrianPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    final phone = value.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^(09|00963|\+963)\d{8}$').hasMatch(phone)) {
      return 'رقم هاتف سوري غير صالح';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    }
    if (value.trim().length < 3) {
      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    }
    return null;
  }

  static String? validateAdTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'عنوان الإعلان مطلوب';
    }
    if (value.trim().length < 5) {
      return 'العنوان يجب أن يكون 5 أحرف على الأقل';
    }
    if (value.trim().length > 100) {
      return 'العنوان يجب أن لا يتجاوز 100 حرف';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الوصف مطلوب';
    }
    if (value.trim().length < 20) {
      return 'الوصف يجب أن يكون 20 حرفاً على الأقل';
    }
    if (value.trim().length > 2000) {
      return 'الوصف يجب أن لا يتجاوز 2000 حرف';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'السعر مطلوب';
    }
    final price = double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), ''));
    if (price == null || price <= 0) {
      return 'سعر غير صالح';
    }
    if (price > 999999999) {
      return 'السعر كبير جداً';
    }
    return null;
  }

  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'هذا الحقل'} مطلوب';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'بريد إلكتروني غير صالح';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!Uri.tryParse(value)!.hasScheme) {
      return 'رابط غير صالح';
    }
    return null;
  }
}
