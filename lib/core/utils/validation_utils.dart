class ValidationUtils {
  static String? validateRequired(String? value, String fieldName) {
    if (value?.isEmpty == true) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateNumber(String? value, String fieldName) {
    if (value?.isEmpty == true) return '$fieldName is required';
    if (double.tryParse(value!) == null) return 'Enter a valid number';
    return null;
  }

  static String? validatePositiveNumber(String? value, String fieldName) {
    final numberError = validateNumber(value, fieldName);
    if (numberError != null) return numberError;

    if (double.parse(value!) <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }

  static String? validateCalories(String? value) {
    return validatePositiveNumber(value, 'Calories');
  }
}
