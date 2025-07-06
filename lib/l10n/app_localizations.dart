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
  /// **'grams'**
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
  /// **'calories/day'**
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
  /// **'quick entry'**
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
