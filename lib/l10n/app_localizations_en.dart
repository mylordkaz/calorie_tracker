// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Nibble';

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
  String get average => 'Avg';

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

  @override
  String get healthAndFitnessCalculators => 'Health & Fitness Calculators';

  @override
  String get calculateImportantHealthMetrics => 'Calculate important health metrics';

  @override
  String get tdeeCalculatorDescription => 'Calculate your daily calorie needs';

  @override
  String get bmiCalculatorDescription => 'Calculate your Body Mass Index';

  @override
  String get idealWeightCalculatorDescription => 'Find your ideal weight range';

  @override
  String get bodyFatCalculatorDescription => 'Estimate your body fat percentage';

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get sunday => 'Sun';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get sevenDays => '7 Days';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thirtyDays => '30 Days';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get kcal => 'kcal';

  @override
  String get selectDateToViewDetails => 'Select a date to view details';

  @override
  String get tapOnAnyDayInCalendar => 'Tap on any day in the calendar above';

  @override
  String get noEntriesYet => 'No entries yet';

  @override
  String get addEntry => 'Add Entry';

  @override
  String get entriesLogged => 'entries logged';

  @override
  String get foodLog => 'Food Log';

  @override
  String get quickCalorieEntry => 'Quick Calorie Entry';

  @override
  String get nameRequired => 'Name required';

  @override
  String get foodNameHint => 'e.g., Chicken Breast';

  @override
  String noJustAddToDate(String date) {
    return 'No, just add to $date';
  }

  @override
  String addEntryForDate(String date) {
    return 'Add Entry - $date';
  }

  @override
  String get statistics => 'Statistics';

  @override
  String get deleteEntry => 'Delete Entry';

  @override
  String get confirmDeleteEntry => 'Are you sure you want to delete this entry?';

  @override
  String get entryDeletedSuccessfully => 'Entry deleted successfully';

  @override
  String errorDeletingEntry(String error) {
    return 'Error deleting entry: $error';
  }

  @override
  String get perItem => 'per item';

  @override
  String get perServing => 'per serving';

  @override
  String get per100g => 'per 100g';

  @override
  String get editFood => 'Edit Food';

  @override
  String get addNewFood => 'Add New Food';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get descriptionOptional => 'Description (Optional)';

  @override
  String get briefDescription => 'Brief description of the food item';

  @override
  String get servingSize => 'Serving Size';

  @override
  String get servingSizeHint => 'e.g., 1 cup, 2 slices';

  @override
  String get servingSizeRequired => 'Serving size is required';

  @override
  String get weightOptional => 'Weight (Optional)';

  @override
  String get weightInGrams => 'Weight in grams';

  @override
  String get additionalNutrients => 'Additional Nutrients';

  @override
  String get nutrientName => 'Nutrient name';

  @override
  String get nutrientNameHint => 'e.g., Fiber, Sodium';

  @override
  String get amount => 'amount';

  @override
  String get value => 'Value';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get valueRequired => 'Value required';

  @override
  String get updateFood => 'Update Food';

  @override
  String get saveFood => 'Save Food';

  @override
  String get photoOptional => 'Photo (Optional)';

  @override
  String get tapToAdd => 'Tap to add photo';

  @override
  String get selectImageSource => 'Select Image Source';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get enterValidNumber => 'Enter a valid number';

  @override
  String get noFoodsYet => 'No foods in your library yet';

  @override
  String get addFirstFood => 'Add your first food to get started';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get change => 'Change';

  @override
  String get remove => 'remove';

  @override
  String get standardNutritionInfo => 'Standard nutrition information per 100 grams';

  @override
  String get itemNutritionInfo => 'For foods like eggs, slices of bread, etc.';

  @override
  String get servingNutritionInfo => 'US-style serving size (e.g., 1 cup, 2 slices)';

  @override
  String get deleteFood => 'Delete Food';

  @override
  String deleteFoodConfirmation(Object name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get nutritionFacts => 'Nutrition Facts';

  @override
  String nutritionFactsPer(Object unit) {
    return 'Nutrition Facts ($unit)';
  }

  @override
  String get usageStats => 'Usage Statistics';

  @override
  String get created => 'Created';

  @override
  String get lastUsed => 'Last Used';

  @override
  String get timesUsed => 'Times Used';

  @override
  String totalWeight(int weight) {
    return 'Total Weight: ${weight}g';
  }

  @override
  String get foodDeleted => 'Food deleted successfully';

  @override
  String unitWeight(Object weight) {
    return 'Unit Weight: ($weight)g';
  }

  @override
  String get noFoodInLib => 'No foods in your library yet';

  @override
  String get noFoodMatch => 'No foods match your search';

  @override
  String get tapAddFood => 'Tap the + button to add your first food';

  @override
  String get trySearchTerm => 'Try a different search term';

  @override
  String totalWeightShort(Object weight) {
    return '${weight}g total';
  }

  @override
  String get editMeal => 'Edit Meal';

  @override
  String get createNewMeal => 'Create New Meal';

  @override
  String get mealName => 'Meal Name';

  @override
  String get mealNameHint => 'e.g., Chicken & Rice Bowl';

  @override
  String get mealDescHint => 'High protein meal';

  @override
  String get category => 'Category';

  @override
  String get categoryHint => 'Lunch';

  @override
  String ingredients(int count) {
    return 'Ingredients ($count)';
  }

  @override
  String get noIngredientsYet => 'No ingredients added yet';

  @override
  String get tapAddIngredientHint => 'Tap \"Add Ingredient\" to start building your meal';

  @override
  String get pleaseAddOneIngredient => 'Please add at least one ingredient';

  @override
  String get saveMeal => 'Save Meal';

  @override
  String get updateMeal => 'Update Meal';

  @override
  String get nutritionSummary => 'Nutrition Summary';

  @override
  String get addIngredient => 'Add Ingredient';

  @override
  String selectedFood(String foodName) {
    return 'Selected: $foodName';
  }

  @override
  String nutritionFor(String quantity) {
    return 'Nutrition for $quantity:';
  }

  @override
  String get favorite => 'Favorite';

  @override
  String get nutritionFactsTotal => 'Nutrition Facts (Total)';

  @override
  String get usageStatistics => 'Usage Statistics';

  @override
  String get deleteMeal => 'Delete Meal';

  @override
  String deleteMealConfirmation(String mealName) {
    return 'Are you sure you want to delete \"$mealName\"? This action cannot be undone.';
  }

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get missingFood => 'Missing Food Item';

  @override
  String foodId(String id) {
    return 'Food ID: $id';
  }

  @override
  String get noMealsInLibrary => 'No meals in your library yet';

  @override
  String get noMealsMatchSearch => 'No meals match your search';

  @override
  String get tapPlusButtonCreateMeal => 'Tap the + button to create your first meal';

  @override
  String ingredientsWithTotal(int count, int weight) {
    return '$count ingredients • ${weight}g total';
  }

  @override
  String perServings(String serving) {
    return 'per $serving';
  }

  @override
  String get accessControlFullAccessPurchased => 'Full access purchased';

  @override
  String get accessControlPromoActive => 'Promo access active';

  @override
  String get accessControlTrialAvailable => '14-day free trial available';

  @override
  String accessControlTrialExpiresIn(int days) {
    return 'Trial expires in $days days';
  }

  @override
  String get accessControlTrialExpiresToday => 'Trial expires today';

  @override
  String accessControlDaysRemaining(int days) {
    return '$days days remaining in trial';
  }

  @override
  String get accessControlTrialExpired => 'Trial expired - purchase required';

  @override
  String get accessControlCheckingAccess => 'Checking access...';

  @override
  String get accessControlUpgrade => 'Upgrade';

  @override
  String get accessControlTrialAlreadyUsed => 'Trial already used on this account';

  @override
  String accessControlErrorStartingTrial(String error) {
    return 'Error starting trial: $error';
  }

  @override
  String accessControlPurchaseFailed(String error) {
    return 'Purchase failed: $error';
  }

  @override
  String get appTagline => 'Track calories, own your data';

  @override
  String get purchaseStartFreeTrial => 'Start 14-Day Free Trial';

  @override
  String get purchaseUnlockFullAccess => 'Unlock Full Access';

  @override
  String purchaseOneTimePayment(String price) {
    return '$price - One time payment';
  }

  @override
  String get purchaseBenefitNoSubscriptions => 'No subscriptions - pay once, use forever';

  @override
  String get purchaseBenefitDataPrivacy => 'Your data stays on your device';

  @override
  String get purchaseBenefitNoAds => 'No ads, no tracking';

  @override
  String get purchaseBenefitUnlimited => 'Unlimited custom foods and meals';

  @override
  String get purchaseTermsAndPrivacy => 'By purchasing, you agree to our Terms of Service and Privacy Policy';

  @override
  String get havePromoCode => 'Have a promo code?';

  @override
  String get enterPromoCode => 'Enter promo code';

  @override
  String get redeemCode => 'Redeem Code';

  @override
  String get trialStarted => 'Trial Started!';

  @override
  String get yourTrialBegun => 'Your 14-days free trial has begun';

  @override
  String get trialEndOn => 'Trial ends on';

  @override
  String get startUsing => 'Start using Nibble';

  @override
  String get welcome => 'Welcome to Nibble';

  @override
  String get yourPrivateCalTracker => 'Your private calorie tracker';

  @override
  String get yourDataStaysPrivate => 'Your data stays private';

  @override
  String get noCloudAllLocal => 'No cloud servers, everything local';

  @override
  String get fastSimpleTracking => 'Fast & simple tracking';

  @override
  String get customLibsByYou => 'Custom food library built by you';

  @override
  String get payOnceUseForever => 'Pay once, use forever';

  @override
  String get noSubNoHiddenFee => 'No subscriptions or hidden fees';

  @override
  String get getStarted => 'Get Started';

  @override
  String get promoCodeRedeemed => 'Promo Code Redeemed!';

  @override
  String promoCodeRedeemedDescription(String promoCode) {
    return 'Your promo code \"$promoCode\" has been successfully redeemed. You now have full access to Nibble!';
  }

  @override
  String get fullAccessActivated => 'Full access activated';

  @override
  String get invalidPromoCode => 'Invalid Promo Code';

  @override
  String get exportFoodLibrary => 'Export Food Library';

  @override
  String get exportMealLibrary => 'Export Meal Library';

  @override
  String get exportCalendarData => 'Export Calendar Data';

  @override
  String get exportFoods => 'Export Foods';

  @override
  String get exportMeals => 'Export Meals';

  @override
  String get exportFoodLibraryDescription => 'Export all your custom foods to a CSV file?\n\nThis will include food names, nutritional information, and usage statistics.';

  @override
  String get exportMealLibraryDescription => 'Export all your custom meals to a CSV file?\n\nThis will include meal recipes, ingredients, and nutritional calculations.';

  @override
  String get chooseTimePeriodToExport => 'Choose the time period to export:';

  @override
  String get chooseDateRange => 'Choose date range';

  @override
  String get allTime => 'All time';

  @override
  String get exportFoodLibrarySuccess => 'Food library exported successfully!';

  @override
  String get exportMealLibrarySuccess => 'Meal library exported successfully!';

  @override
  String get exportCalendarDataSuccess => 'Calendar data exported successfully!';

  @override
  String get exportFailed => 'Export Failed';

  @override
  String get export => 'Export';

  @override
  String get importFoods => 'Import Foods';

  @override
  String get importMeals => 'Import Meals';

  @override
  String get importFoodLibrary => 'Import Food Library';

  @override
  String get importMealLibrary => 'Import Meal Library';

  @override
  String get importFoodLibraryDescription => 'Import foods from a CSV file?\n\nThis will add foods to your library. Duplicate foods will be skipped.';

  @override
  String get importMealLibraryDescription => 'Import meals from a CSV file?\n\nThis will add meals to your library. Duplicate meals will be skipped.';

  @override
  String get import => 'Import';

  @override
  String get importFailed => 'Import Failed';
}
