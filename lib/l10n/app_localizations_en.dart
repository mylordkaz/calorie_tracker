// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Calorie Tracker';

  @override
  String get home => 'Home';

  @override
  String get library => 'Library';

  @override
  String get stats => 'Stats';

  @override
  String get tools => 'Tools';

  @override
  String get foods => 'Foods';

  @override
  String get meals => 'Meals';

  @override
  String get addFood => 'Add Food';

  @override
  String get addMeal => 'Add Meal';

  @override
  String get searchFoods => 'Search foods...';

  @override
  String get searchMeals => 'Search meals...';

  @override
  String get calories => 'Calories';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Carbs';

  @override
  String get fat => 'Fat';

  @override
  String get grams => 'Grams';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get today => 'Today';

  @override
  String get target => 'Target';

  @override
  String get ofText => 'of';

  @override
  String get to => 'to';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get quickStats => 'Quick Stats';

  @override
  String get todaysLog => 'Today\'s Log';

  @override
  String get copyFromYesterday => 'Copy from Yesterday';

  @override
  String get addAllYesterdayEntries => 'Add all yesterday\'s entries to today';

  @override
  String get noEntriesLoggedYet => 'No entries logged today yet';

  @override
  String get tapAddFoodToStart => 'Tap \"Add Food\" to start tracking';

  @override
  String get viewAll => 'View All';

  @override
  String get weeklyAverage => 'Weekly Average';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get remaining => 'Remaining';

  @override
  String get progress => 'Progress';

  @override
  String get caloriesPerDay => 'calories/day';

  @override
  String get todaysCompleteLog => 'Today\'s Complete Log';

  @override
  String get close => 'Close';

  @override
  String get quickEntry => 'Quick Entry';

  @override
  String get serving => 'serving';

  @override
  String get servings => 'Servings';

  @override
  String get copiedEntriesFromYesterday => 'Copied entries from yesterday';

  @override
  String get noEntriesFoundYesterday => 'No entries found for yesterday';

  @override
  String get dailyCalorieTarget => 'Daily Calorie Target';

  @override
  String dailyTargetUpdated(Object calories) {
    return 'Daily target updated to $calories calories';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String entriesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '1 entry',
      zero: '0 entries',
    );
    return '$_temp0';
  }

  @override
  String targetWithValue(Object value) {
    return 'Target: $value';
  }

  @override
  String get setTarget => 'Set Target';

  @override
  String get setDailyTarget => 'Set Daily Calorie Target';

  @override
  String todayWithDate(Object date) {
    return 'Today - $date';
  }

  @override
  String get cal => 'cal';

  @override
  String get addFoodEntry => 'Add Food Entry';

  @override
  String get foodName => 'Food Name';

  @override
  String get nutritionDetailsOptional => 'Nutrition Details (Optional)';

  @override
  String get nutritionEditLater => 'These can be edited later in the food library';

  @override
  String get addQuickEntry => 'Add Quick Entry';

  @override
  String get quantity => 'Quantity';

  @override
  String get unit => 'Unit';

  @override
  String get items => 'Items';

  @override
  String get add => 'Add';

  @override
  String get saveToLibrary => 'Save to Library?';

  @override
  String saveToLibraryPrompt(String name) {
    return 'Do you want to save \"$name\" to your food library for future use?';
  }

  @override
  String get noJustAddToday => 'No, just add today';

  @override
  String get yesSaveToLibrary => 'Yes, save to library';

  @override
  String addFoodTitle(String foodName) {
    return 'Add $foodName';
  }

  @override
  String addMealTitle(String mealName) {
    return 'Add $mealName';
  }

  @override
  String get servingsHelperText => '1.0 = full meal, 0.5 = half meal';

  @override
  String addedFoodToLog(String foodName) {
    return 'Added $foodName to today\'s log';
  }

  @override
  String addedMealToLog(String mealName) {
    return 'Added $mealName to today\'s log';
  }

  @override
  String savedToLibraryAndAdded(String name) {
    return '$name saved to library and added to today\'s log';
  }

  @override
  String addedWithCalories(String name, int calories) {
    return 'Added $name ($calories cal) to today\'s log';
  }

  @override
  String get editInLibrary => 'Edit in Library';

  @override
  String get noFoodsFound => 'No foods found';

  @override
  String get noMealsFound => 'No meals found';

  @override
  String ingredientsCount(int count) {
    return '$count ingredients';
  }

  @override
  String get hintZero => '0';

  @override
  String fieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get quickEntryLower => 'quick entry';
}
