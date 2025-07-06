import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Nibble'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tools;

  /// No description provided for @foods.
  ///
  /// In en, this message translates to:
  /// **'Foods'**
  String get foods;

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// No description provided for @addFood.
  ///
  /// In en, this message translates to:
  /// **'Add Food'**
  String get addFood;

  /// No description provided for @addMeal.
  ///
  /// In en, this message translates to:
  /// **'Add Meal'**
  String get addMeal;

  /// No description provided for @searchFoods.
  ///
  /// In en, this message translates to:
  /// **'Search foods...'**
  String get searchFoods;

  /// No description provided for @searchMeals.
  ///
  /// In en, this message translates to:
  /// **'Search meals...'**
  String get searchMeals;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @grams.
  ///
  /// In en, this message translates to:
  /// **'Grams'**
  String get grams;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @ofText.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofText;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @quickStats.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get quickStats;

  /// No description provided for @todaysLog.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Log'**
  String get todaysLog;

  /// No description provided for @copyFromYesterday.
  ///
  /// In en, this message translates to:
  /// **'Copy from Yesterday'**
  String get copyFromYesterday;

  /// No description provided for @addAllYesterdayEntries.
  ///
  /// In en, this message translates to:
  /// **'Add all yesterday\'s entries to today'**
  String get addAllYesterdayEntries;

  /// No description provided for @noEntriesLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'No entries logged today yet'**
  String get noEntriesLoggedYet;

  /// No description provided for @tapAddFoodToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add Food\" to start tracking'**
  String get tapAddFoodToStart;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @weeklyAverage.
  ///
  /// In en, this message translates to:
  /// **'Weekly Average'**
  String get weeklyAverage;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @caloriesPerDay.
  ///
  /// In en, this message translates to:
  /// **'calories per day'**
  String get caloriesPerDay;

  /// No description provided for @todaysCompleteLog.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Complete Log'**
  String get todaysCompleteLog;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @quickEntry.
  ///
  /// In en, this message translates to:
  /// **'Quick Entry'**
  String get quickEntry;

  /// No description provided for @serving.
  ///
  /// In en, this message translates to:
  /// **'serving'**
  String get serving;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'servings'**
  String get servings;

  /// No description provided for @copiedEntriesFromYesterday.
  ///
  /// In en, this message translates to:
  /// **'Copied entries from yesterday'**
  String get copiedEntriesFromYesterday;

  /// No description provided for @noEntriesFoundYesterday.
  ///
  /// In en, this message translates to:
  /// **'No entries found for yesterday'**
  String get noEntriesFoundYesterday;

  /// No description provided for @dailyCalorieTarget.
  ///
  /// In en, this message translates to:
  /// **'Daily Calorie Target'**
  String get dailyCalorieTarget;

  /// No description provided for @dailyTargetUpdated.
  ///
  /// In en, this message translates to:
  /// **'Daily target updated to {calories} calories'**
  String dailyTargetUpdated(Object calories);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @entriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 entries} =1{1 entry} other{{count} entries}}'**
  String entriesCount(num count);

  /// No description provided for @targetWithValue.
  ///
  /// In en, this message translates to:
  /// **'Target: {value}'**
  String targetWithValue(Object value);

  /// No description provided for @setTarget.
  ///
  /// In en, this message translates to:
  /// **'Set Target'**
  String get setTarget;

  /// No description provided for @setDailyTarget.
  ///
  /// In en, this message translates to:
  /// **'Set Daily Calorie Target'**
  String get setDailyTarget;

  /// No description provided for @todayWithDate.
  ///
  /// In en, this message translates to:
  /// **'Today - {date}'**
  String todayWithDate(Object date);

  /// No description provided for @cal.
  ///
  /// In en, this message translates to:
  /// **'cal'**
  String get cal;

  /// No description provided for @addFoodEntry.
  ///
  /// In en, this message translates to:
  /// **'Add Food Entry'**
  String get addFoodEntry;

  /// No description provided for @foodName.
  ///
  /// In en, this message translates to:
  /// **'Food Name'**
  String get foodName;

  /// No description provided for @nutritionDetailsOptional.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Details (Optional)'**
  String get nutritionDetailsOptional;

  /// No description provided for @nutritionEditLater.
  ///
  /// In en, this message translates to:
  /// **'These can be edited later in the food library'**
  String get nutritionEditLater;

  /// No description provided for @addQuickEntry.
  ///
  /// In en, this message translates to:
  /// **'Add Quick Entry'**
  String get addQuickEntry;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @saveToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Save to Library?'**
  String get saveToLibrary;

  /// No description provided for @saveToLibraryPrompt.
  ///
  /// In en, this message translates to:
  /// **'Do you want to save \"{name}\" to your food library for future use?'**
  String saveToLibraryPrompt(String name);

  /// No description provided for @noJustAddToday.
  ///
  /// In en, this message translates to:
  /// **'No, just add today'**
  String get noJustAddToday;

  /// No description provided for @yesSaveToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Yes, save to library'**
  String get yesSaveToLibrary;

  /// No description provided for @addFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {foodName}'**
  String addFoodTitle(String foodName);

  /// No description provided for @addMealTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {mealName}'**
  String addMealTitle(String mealName);

  /// No description provided for @servingsHelperText.
  ///
  /// In en, this message translates to:
  /// **'1.0 = full meal, 0.5 = half meal'**
  String get servingsHelperText;

  /// No description provided for @addedFoodToLog.
  ///
  /// In en, this message translates to:
  /// **'Added {foodName} to today\'s log'**
  String addedFoodToLog(String foodName);

  /// No description provided for @addedMealToLog.
  ///
  /// In en, this message translates to:
  /// **'Added {mealName} to today\'s log'**
  String addedMealToLog(String mealName);

  /// No description provided for @savedToLibraryAndAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} saved to library and added to today\'s log'**
  String savedToLibraryAndAdded(String name);

  /// No description provided for @addedWithCalories.
  ///
  /// In en, this message translates to:
  /// **'Added {name} ({calories} cal) to today\'s log'**
  String addedWithCalories(String name, int calories);

  /// No description provided for @editInLibrary.
  ///
  /// In en, this message translates to:
  /// **'Edit in Library'**
  String get editInLibrary;

  /// No description provided for @noFoodsFound.
  ///
  /// In en, this message translates to:
  /// **'No foods found'**
  String get noFoodsFound;

  /// No description provided for @noMealsFound.
  ///
  /// In en, this message translates to:
  /// **'No meals found'**
  String get noMealsFound;

  /// No description provided for @ingredientsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ingredients'**
  String ingredientsCount(int count);

  /// No description provided for @hintZero.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get hintZero;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String fieldRequired(String field);

  /// No description provided for @quickEntryLower.
  ///
  /// In en, this message translates to:
  /// **'quick entry'**
  String get quickEntryLower;

  /// No description provided for @bmiCalculator.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get bmiCalculator;

  /// No description provided for @bodyMassIndex.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index'**
  String get bodyMassIndex;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @yourBmiResult.
  ///
  /// In en, this message translates to:
  /// **'Your BMI Result'**
  String get yourBmiResult;

  /// No description provided for @calculateBmi.
  ///
  /// In en, this message translates to:
  /// **'Calculate BMI'**
  String get calculateBmi;

  /// No description provided for @bmiCategories.
  ///
  /// In en, this message translates to:
  /// **'BMI Categories'**
  String get bmiCategories;

  /// No description provided for @underweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get underweight;

  /// No description provided for @normalWeight.
  ///
  /// In en, this message translates to:
  /// **'Normal weight'**
  String get normalWeight;

  /// No description provided for @overweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get overweight;

  /// No description provided for @obese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get obese;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalid;

  /// No description provided for @bodyFatCalculator.
  ///
  /// In en, this message translates to:
  /// **'Body Fat Calculator'**
  String get bodyFatCalculator;

  /// No description provided for @estimateBodyFatPercentage.
  ///
  /// In en, this message translates to:
  /// **'Estimate body fat percentage (US Navy Method)'**
  String get estimateBodyFatPercentage;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @neck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get neck;

  /// No description provided for @waist.
  ///
  /// In en, this message translates to:
  /// **'Waist'**
  String get waist;

  /// No description provided for @hip.
  ///
  /// In en, this message translates to:
  /// **'Hip'**
  String get hip;

  /// No description provided for @bodyMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Body Measurements'**
  String get bodyMeasurements;

  /// No description provided for @measurementInstructions.
  ///
  /// In en, this message translates to:
  /// **'Measurement Instructions'**
  String get measurementInstructions;

  /// No description provided for @calculateBodyFat.
  ///
  /// In en, this message translates to:
  /// **'Calculate Body Fat'**
  String get calculateBodyFat;

  /// No description provided for @bodyFatCategories.
  ///
  /// In en, this message translates to:
  /// **'Body Fat Categories'**
  String get bodyFatCategories;

  /// No description provided for @bodyFatCategoriesMen.
  ///
  /// In en, this message translates to:
  /// **'Body Fat Categories (Men)'**
  String get bodyFatCategoriesMen;

  /// No description provided for @bodyFatCategoriesWomen.
  ///
  /// In en, this message translates to:
  /// **'Body Fat Categories (Women)'**
  String get bodyFatCategoriesWomen;

  /// No description provided for @essentialFat.
  ///
  /// In en, this message translates to:
  /// **'Essential Fat'**
  String get essentialFat;

  /// No description provided for @athletes.
  ///
  /// In en, this message translates to:
  /// **'Athletes'**
  String get athletes;

  /// No description provided for @fitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get fitness;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get average;

  /// No description provided for @yourBodyFatResult.
  ///
  /// In en, this message translates to:
  /// **'Your Body Fat Result'**
  String get yourBodyFatResult;

  /// No description provided for @neckMeasurementTip.
  ///
  /// In en, this message translates to:
  /// **'• Neck: Measure below the larynx'**
  String get neckMeasurementTip;

  /// No description provided for @waistMeasurementTip.
  ///
  /// In en, this message translates to:
  /// **'• Waist: Measure at the narrowest point'**
  String get waistMeasurementTip;

  /// No description provided for @hipMeasurementTip.
  ///
  /// In en, this message translates to:
  /// **'• Hip: Measure at the widest point'**
  String get hipMeasurementTip;

  /// No description provided for @measurementAccuracyTip.
  ///
  /// In en, this message translates to:
  /// **'• Measure without clothes for accuracy'**
  String get measurementAccuracyTip;

  /// No description provided for @hipMeasurementRequired.
  ///
  /// In en, this message translates to:
  /// **'Hip measurement is required for women'**
  String get hipMeasurementRequired;

  /// No description provided for @usNavyMethod.
  ///
  /// In en, this message translates to:
  /// **'US Navy Method'**
  String get usNavyMethod;

  /// No description provided for @usNavyDesc.
  ///
  /// In en, this message translates to:
  /// **'Developed by the US Navy, this method estimates body fat using body circumference measurements. Results are estimates and may vary from other methods.'**
  String get usNavyDesc;

  /// No description provided for @idealWeightCalculator.
  ///
  /// In en, this message translates to:
  /// **'Ideal Weight Calculator'**
  String get idealWeightCalculator;

  /// No description provided for @findIdealWeightRange.
  ///
  /// In en, this message translates to:
  /// **'Find your ideal weight range (Robinson Formula)'**
  String get findIdealWeightRange;

  /// No description provided for @calculateIdealWeight.
  ///
  /// In en, this message translates to:
  /// **'Calculate Ideal Weight'**
  String get calculateIdealWeight;

  /// No description provided for @yourIdealWeight.
  ///
  /// In en, this message translates to:
  /// **'Your Ideal Weight'**
  String get yourIdealWeight;

  /// No description provided for @idealWeight.
  ///
  /// In en, this message translates to:
  /// **'ideal weight'**
  String get idealWeight;

  /// No description provided for @healthyWeightRange.
  ///
  /// In en, this message translates to:
  /// **'Healthy Weight Range'**
  String get healthyWeightRange;

  /// No description provided for @rangeBasedOnIdealWeight.
  ///
  /// In en, this message translates to:
  /// **'Range based on ±5kg from ideal weight'**
  String get rangeBasedOnIdealWeight;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current Weight: {weight}kg'**
  String currentWeight(String weight);

  /// No description provided for @withinIdealRange.
  ///
  /// In en, this message translates to:
  /// **'Within ideal range'**
  String get withinIdealRange;

  /// No description provided for @aboveIdeal.
  ///
  /// In en, this message translates to:
  /// **'{difference}kg above ideal'**
  String aboveIdeal(String difference);

  /// No description provided for @belowIdeal.
  ///
  /// In en, this message translates to:
  /// **'{difference}kg below ideal'**
  String belowIdeal(String difference);

  /// No description provided for @robinsonFormula.
  ///
  /// In en, this message translates to:
  /// **'Robinson Formula'**
  String get robinsonFormula;

  /// No description provided for @robinsonFormulaMen.
  ///
  /// In en, this message translates to:
  /// **'Men: 52kg + 1.9kg per inch over 5 feet'**
  String get robinsonFormulaMen;

  /// No description provided for @robinsonFormulaWomen.
  ///
  /// In en, this message translates to:
  /// **'Women: 49kg + 1.7kg per inch over 5 feet'**
  String get robinsonFormulaWomen;

  /// No description provided for @tdeeCalculator.
  ///
  /// In en, this message translates to:
  /// **'TDEE Calculator'**
  String get tdeeCalculator;

  /// No description provided for @totalDailyEnergyExpenditure.
  ///
  /// In en, this message translates to:
  /// **'Total Daily Energy Expenditure'**
  String get totalDailyEnergyExpenditure;

  /// No description provided for @activityLevel.
  ///
  /// In en, this message translates to:
  /// **'Activity Level'**
  String get activityLevel;

  /// No description provided for @calculateTdee.
  ///
  /// In en, this message translates to:
  /// **'Calculate TDEE'**
  String get calculateTdee;

  /// No description provided for @yourTdeeResult.
  ///
  /// In en, this message translates to:
  /// **'Your TDEE Result'**
  String get yourTdeeResult;

  /// No description provided for @tdeeMaintenanceDescription.
  ///
  /// In en, this message translates to:
  /// **'This is your estimated daily calorie needs to maintain your current weight.'**
  String get tdeeMaintenanceDescription;

  /// No description provided for @setAsDailyCalorieTarget.
  ///
  /// In en, this message translates to:
  /// **'Set as Daily Calorie Target'**
  String get setAsDailyCalorieTarget;

  /// No description provided for @dailyCalorieTargetUpdatedTo.
  ///
  /// In en, this message translates to:
  /// **'Daily calorie target updated to {calories} calories'**
  String dailyCalorieTargetUpdatedTo(int calories);

  /// No description provided for @sedentaryNoExercise.
  ///
  /// In en, this message translates to:
  /// **'Sedentary (no exercise)'**
  String get sedentaryNoExercise;

  /// No description provided for @lightOneToTwoDays.
  ///
  /// In en, this message translates to:
  /// **'Light (1-2 days/week)'**
  String get lightOneToTwoDays;

  /// No description provided for @lightTwoToThreeDays.
  ///
  /// In en, this message translates to:
  /// **'Light (2-3 days/week)'**
  String get lightTwoToThreeDays;

  /// No description provided for @moderateThreeToFourDays.
  ///
  /// In en, this message translates to:
  /// **'Moderate (3-4 days/week)'**
  String get moderateThreeToFourDays;

  /// No description provided for @moderateFourToFiveDays.
  ///
  /// In en, this message translates to:
  /// **'Moderate (4-5 days/week)'**
  String get moderateFourToFiveDays;

  /// No description provided for @activeSixToSevenDays.
  ///
  /// In en, this message translates to:
  /// **'Active (6-7 days/week)'**
  String get activeSixToSevenDays;

  /// No description provided for @veryActiveTwiceDaily.
  ///
  /// In en, this message translates to:
  /// **'Very Active (2x daily)'**
  String get veryActiveTwiceDaily;

  /// No description provided for @extremelyActivePhysicalJob.
  ///
  /// In en, this message translates to:
  /// **'Extreme (physical job)'**
  String get extremelyActivePhysicalJob;

  /// No description provided for @healthAndFitnessCalculators.
  ///
  /// In en, this message translates to:
  /// **'Health & Fitness Calculators'**
  String get healthAndFitnessCalculators;

  /// No description provided for @calculateImportantHealthMetrics.
  ///
  /// In en, this message translates to:
  /// **'Calculate important health metrics'**
  String get calculateImportantHealthMetrics;

  /// No description provided for @tdeeCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculate your daily calorie needs'**
  String get tdeeCalculatorDescription;

  /// No description provided for @bmiCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculate your Body Mass Index'**
  String get bmiCalculatorDescription;

  /// No description provided for @idealWeightCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Find your ideal weight range'**
  String get idealWeightCalculatorDescription;

  /// No description provided for @bodyFatCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Estimate your body fat percentage'**
  String get bodyFatCalculatorDescription;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @sevenDays.
  ///
  /// In en, this message translates to:
  /// **'7 Days'**
  String get sevenDays;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thirtyDays.
  ///
  /// In en, this message translates to:
  /// **'30 Days'**
  String get thirtyDays;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @kcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcal;

  /// No description provided for @selectDateToViewDetails.
  ///
  /// In en, this message translates to:
  /// **'Select a date to view details'**
  String get selectDateToViewDetails;

  /// No description provided for @tapOnAnyDayInCalendar.
  ///
  /// In en, this message translates to:
  /// **'Tap on any day in the calendar above'**
  String get tapOnAnyDayInCalendar;

  /// No description provided for @noEntriesYet.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get noEntriesYet;

  /// No description provided for @addEntry.
  ///
  /// In en, this message translates to:
  /// **'Add Entry'**
  String get addEntry;

  /// No description provided for @entriesLogged.
  ///
  /// In en, this message translates to:
  /// **'entries logged'**
  String get entriesLogged;

  /// No description provided for @foodLog.
  ///
  /// In en, this message translates to:
  /// **'Food Log'**
  String get foodLog;

  /// No description provided for @quickCalorieEntry.
  ///
  /// In en, this message translates to:
  /// **'Quick Calorie Entry'**
  String get quickCalorieEntry;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name required'**
  String get nameRequired;

  /// No description provided for @foodNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Chicken Breast'**
  String get foodNameHint;

  /// No description provided for @noJustAddToDate.
  ///
  /// In en, this message translates to:
  /// **'No, just add to {date}'**
  String noJustAddToDate(String date);

  /// No description provided for @addEntryForDate.
  ///
  /// In en, this message translates to:
  /// **'Add Entry - {date}'**
  String addEntryForDate(String date);

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @deleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete Entry'**
  String get deleteEntry;

  /// No description provided for @confirmDeleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this entry?'**
  String get confirmDeleteEntry;

  /// No description provided for @entryDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted successfully'**
  String get entryDeletedSuccessfully;

  /// No description provided for @errorDeletingEntry.
  ///
  /// In en, this message translates to:
  /// **'Error deleting entry: {error}'**
  String errorDeletingEntry(String error);

  /// No description provided for @perItem.
  ///
  /// In en, this message translates to:
  /// **'per item'**
  String get perItem;

  /// No description provided for @perServing.
  ///
  /// In en, this message translates to:
  /// **'per serving'**
  String get perServing;

  /// No description provided for @per100g.
  ///
  /// In en, this message translates to:
  /// **'per 100g'**
  String get per100g;

  /// No description provided for @editFood.
  ///
  /// In en, this message translates to:
  /// **'Edit Food'**
  String get editFood;

  /// No description provided for @addNewFood.
  ///
  /// In en, this message translates to:
  /// **'Add New Food'**
  String get addNewFood;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @briefDescription.
  ///
  /// In en, this message translates to:
  /// **'Brief description of the food item'**
  String get briefDescription;

  /// No description provided for @servingSize.
  ///
  /// In en, this message translates to:
  /// **'Serving Size'**
  String get servingSize;

  /// No description provided for @servingSizeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 1 cup, 2 slices'**
  String get servingSizeHint;

  /// No description provided for @servingSizeRequired.
  ///
  /// In en, this message translates to:
  /// **'Serving size is required'**
  String get servingSizeRequired;

  /// No description provided for @weightOptional.
  ///
  /// In en, this message translates to:
  /// **'Weight (Optional)'**
  String get weightOptional;

  /// No description provided for @weightInGrams.
  ///
  /// In en, this message translates to:
  /// **'Weight in grams'**
  String get weightInGrams;

  /// No description provided for @additionalNutrients.
  ///
  /// In en, this message translates to:
  /// **'Additional Nutrients'**
  String get additionalNutrients;

  /// No description provided for @nutrientName.
  ///
  /// In en, this message translates to:
  /// **'Nutrient name'**
  String get nutrientName;

  /// No description provided for @nutrientNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Fiber, Sodium'**
  String get nutrientNameHint;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'amount'**
  String get amount;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @valueRequired.
  ///
  /// In en, this message translates to:
  /// **'Value required'**
  String get valueRequired;

  /// No description provided for @updateFood.
  ///
  /// In en, this message translates to:
  /// **'Update Food'**
  String get updateFood;

  /// No description provided for @saveFood.
  ///
  /// In en, this message translates to:
  /// **'Save Food'**
  String get saveFood;

  /// No description provided for @photoOptional.
  ///
  /// In en, this message translates to:
  /// **'Photo (Optional)'**
  String get photoOptional;

  /// No description provided for @tapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap to add photo'**
  String get tapToAdd;

  /// No description provided for @selectImageSource.
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get enterValidNumber;

  /// No description provided for @noFoodsYet.
  ///
  /// In en, this message translates to:
  /// **'No foods in your library yet'**
  String get noFoodsYet;

  /// No description provided for @addFirstFood.
  ///
  /// In en, this message translates to:
  /// **'Add your first food to get started'**
  String get addFirstFood;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'remove'**
  String get remove;

  /// No description provided for @standardNutritionInfo.
  ///
  /// In en, this message translates to:
  /// **'Standard nutrition information per 100 grams'**
  String get standardNutritionInfo;

  /// No description provided for @itemNutritionInfo.
  ///
  /// In en, this message translates to:
  /// **'For foods like eggs, slices of bread, etc.'**
  String get itemNutritionInfo;

  /// No description provided for @servingNutritionInfo.
  ///
  /// In en, this message translates to:
  /// **'US-style serving size (e.g., 1 cup, 2 slices)'**
  String get servingNutritionInfo;

  /// No description provided for @deleteFood.
  ///
  /// In en, this message translates to:
  /// **'Delete Food'**
  String get deleteFood;

  /// No description provided for @deleteFoodConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String deleteFoodConfirmation(Object name);

  /// No description provided for @nutritionFacts.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Facts'**
  String get nutritionFacts;

  /// No description provided for @nutritionFactsPer.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Facts ({unit})'**
  String nutritionFactsPer(Object unit);

  /// No description provided for @usageStats.
  ///
  /// In en, this message translates to:
  /// **'Usage Statistics'**
  String get usageStats;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @lastUsed.
  ///
  /// In en, this message translates to:
  /// **'Last Used'**
  String get lastUsed;

  /// No description provided for @timesUsed.
  ///
  /// In en, this message translates to:
  /// **'Times Used'**
  String get timesUsed;

  /// No description provided for @totalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Weight: {weight}g'**
  String totalWeight(Object weight);

  /// No description provided for @foodDeleted.
  ///
  /// In en, this message translates to:
  /// **'Food deleted successfully'**
  String get foodDeleted;

  /// No description provided for @unitWeight.
  ///
  /// In en, this message translates to:
  /// **'Unit Weight: ({weight})g'**
  String unitWeight(Object weight);

  /// No description provided for @noFoodInLib.
  ///
  /// In en, this message translates to:
  /// **'No foods in your library yet'**
  String get noFoodInLib;

  /// No description provided for @noFoodMatch.
  ///
  /// In en, this message translates to:
  /// **'No foods match your search'**
  String get noFoodMatch;

  /// No description provided for @tapAddFood.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add your first food'**
  String get tapAddFood;

  /// No description provided for @trySearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get trySearchTerm;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
