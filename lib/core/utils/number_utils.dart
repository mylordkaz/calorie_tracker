class NumberUtils {
  static String formatCalories(double calories) {
    return calories.toInt().toString();
  }

  static String formatMacro(double value, {int decimals = 1}) {
    return value.toStringAsFixed(value % 1 == 0 ? 0 : decimals);
  }

  static String formatWeight(double weight) {
    return weight.toStringAsFixed(weight % 1 == 0 ? 0 : 1);
  }

  static double parseDoubleOrZero(String value) {
    return double.tryParse(value) ?? 0.0;
  }

  static int parseIntOrZero(String value) {
    return int.tryParse(value) ?? 0;
  }
}
