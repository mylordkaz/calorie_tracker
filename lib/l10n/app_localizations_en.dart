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
  String get grams => 'grams';

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
  String get setTarget => 'Set Daily Calories Target';

  @override
  String get of => 'of';

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
  String get percent => '%';

  @override
  String get todaysCompleteLog => 'Today\'s Complete Log';

  @override
  String get close => 'Close';

  @override
  String get quickEntry => 'quick entry';

  @override
  String get serving => 'serving';

  @override
  String get servings => 'servings';

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
}
