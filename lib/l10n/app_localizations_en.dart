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
  String get caloriesPerDay => 'calories per day';

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

  @override
  String get bmiCalculator => 'BMI Calculator';

  @override
  String get bodyMassIndex => 'Body Mass Index';

  @override
  String get weight => 'Weight';

  @override
  String get height => 'Height';

  @override
  String get yourBmiResult => 'Your BMI Result';

  @override
  String get calculateBmi => 'Calculate BMI';

  @override
  String get bmiCategories => 'BMI Categories';

  @override
  String get underweight => 'Underweight';

  @override
  String get normalWeight => 'Normal weight';

  @override
  String get overweight => 'Overweight';

  @override
  String get obese => 'Obese';

  @override
  String get required => 'Required';

  @override
  String get invalid => 'Invalid';

  @override
  String get bodyFatCalculator => 'Body Fat Calculator';

  @override
  String get estimateBodyFatPercentage => 'Estimate body fat percentage (US Navy Method)';

  @override
  String get age => 'Age';

  @override
  String get years => 'years';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get neck => 'Neck';

  @override
  String get waist => 'Waist';

  @override
  String get hip => 'Hip';

  @override
  String get bodyMeasurements => 'Body Measurements';

  @override
  String get measurementInstructions => 'Measurement Instructions';

  @override
  String get calculateBodyFat => 'Calculate Body Fat';

  @override
  String get bodyFatCategories => 'Body Fat Categories';

  @override
  String get bodyFatCategoriesMen => 'Body Fat Categories (Men)';

  @override
  String get bodyFatCategoriesWomen => 'Body Fat Categories (Women)';

  @override
  String get essentialFat => 'Essential Fat';

  @override
  String get athletes => 'Athletes';

  @override
  String get fitness => 'Fitness';

  @override
  String get average => 'Average';

  @override
  String get yourBodyFatResult => 'Your Body Fat Result';

  @override
  String get neckMeasurementTip => '• Neck: Measure below the larynx';

  @override
  String get waistMeasurementTip => '• Waist: Measure at the narrowest point';

  @override
  String get hipMeasurementTip => '• Hip: Measure at the widest point';

  @override
  String get measurementAccuracyTip => '• Measure without clothes for accuracy';

  @override
  String get hipMeasurementRequired => 'Hip measurement is required for women';

  @override
  String get usNavyMethod => 'US Navy Method';

  @override
  String get usNavyDesc => 'Developed by the US Navy, this method estimates body fat using body circumference measurements. Results are estimates and may vary from other methods.';

  @override
  String get idealWeightCalculator => 'Ideal Weight Calculator';

  @override
  String get findIdealWeightRange => 'Find your ideal weight range (Robinson Formula)';

  @override
  String get calculateIdealWeight => 'Calculate Ideal Weight';

  @override
  String get yourIdealWeight => 'Your Ideal Weight';

  @override
  String get idealWeight => 'ideal weight';

  @override
  String get healthyWeightRange => 'Healthy Weight Range';

  @override
  String get rangeBasedOnIdealWeight => 'Range based on ±5kg from ideal weight';

  @override
  String currentWeight(String weight) {
    return 'Current Weight: ${weight}kg';
  }

  @override
  String get withinIdealRange => 'Within ideal range';

  @override
  String aboveIdeal(String difference) {
    return '${difference}kg above ideal';
  }

  @override
  String belowIdeal(String difference) {
    return '${difference}kg below ideal';
  }

  @override
  String get robinsonFormula => 'Robinson Formula';

  @override
  String get robinsonFormulaMen => 'Men: 52kg + 1.9kg per inch over 5 feet';

  @override
  String get robinsonFormulaWomen => 'Women: 49kg + 1.7kg per inch over 5 feet';

  @override
  String get tdeeCalculator => 'TDEE Calculator';

  @override
  String get totalDailyEnergyExpenditure => 'Total Daily Energy Expenditure';

  @override
  String get activityLevel => 'Activity Level';

  @override
  String get calculateTdee => 'Calculate TDEE';

  @override
  String get yourTdeeResult => 'Your TDEE Result';

  @override
  String get tdeeMaintenanceDescription => 'This is your estimated daily calorie needs to maintain your current weight.';

  @override
  String get setAsDailyCalorieTarget => 'Set as Daily Calorie Target';

  @override
  String dailyCalorieTargetUpdatedTo(int calories) {
    return 'Daily calorie target updated to $calories calories';
  }

  @override
  String get sedentaryNoExercise => 'Sedentary (no exercise)';

  @override
  String get lightOneToTwoDays => 'Light (1-2 days/week)';

  @override
  String get lightTwoToThreeDays => 'Light (2-3 days/week)';

  @override
  String get moderateThreeToFourDays => 'Moderate (3-4 days/week)';

  @override
  String get moderateFourToFiveDays => 'Moderate (4-5 days/week)';

  @override
  String get activeSixToSevenDays => 'Active (6-7 days/week)';

  @override
  String get veryActiveTwiceDaily => 'Very Active (2x daily)';

  @override
  String get extremelyActivePhysicalJob => 'Extreme (physical job)';
}
