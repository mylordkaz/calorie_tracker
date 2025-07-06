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
  /// **'Calorie Tracker'**
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
  /// **'Servings'**
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
  /// **'Average'**
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
