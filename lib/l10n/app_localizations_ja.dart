// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Nibble';

  @override
  String get home => 'ホーム';

  @override
  String get library => 'ライブラリー';

  @override
  String get stats => '統計';

  @override
  String get tools => 'ツール';

  @override
  String get foods => '食品';

  @override
  String get meals => '食事';

  @override
  String get addFood => '食品を追加';

  @override
  String get addMeal => '食事を追加';

  @override
  String get searchFoods => '食品を検索...';

  @override
  String get searchMeals => '食事を検索...';

  @override
  String get calories => 'カロリー';

  @override
  String get protein => 'タンパク質';

  @override
  String get carbs => '炭水化物';

  @override
  String get fat => '脂質';

  @override
  String get grams => 'グラム';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get today => '今日';

  @override
  String get target => '目標';

  @override
  String get ofText => 'の';

  @override
  String get to => 'まで';

  @override
  String get quickActions => 'クイックアクション';

  @override
  String get quickStats => 'クイック統計';

  @override
  String get todaysLog => '今日のログ';

  @override
  String get copyFromYesterday => '昨日からコピー';

  @override
  String get addAllYesterdayEntries => '昨日の全エントリーを今日に追加';

  @override
  String get noEntriesLoggedYet => 'まだ今日のエントリーがありません';

  @override
  String get tapAddFoodToStart => '「食品を追加」をタップして記録を開始';

  @override
  String get viewAll => 'すべて表示';

  @override
  String get weeklyAverage => '週平均';

  @override
  String get yesterday => '昨日';

  @override
  String get remaining => '残り';

  @override
  String get progress => '進捗';

  @override
  String get caloriesPerDay => 'カロリー/日';

  @override
  String get todaysCompleteLog => '今日の完全なログ';

  @override
  String get close => '閉じる';

  @override
  String get quickEntry => 'クイック入力';

  @override
  String get serving => '人分';

  @override
  String get servings => '人分';

  @override
  String get copiedEntriesFromYesterday => '昨日のエントリーをコピーしました';

  @override
  String get noEntriesFoundYesterday => '昨日のエントリーが見つかりません';

  @override
  String get dailyCalorieTarget => '1日のカロリー目標';

  @override
  String dailyTargetUpdated(Object calories) {
    return '1日の目標を$caloriesカロリーに更新しました';
  }

  @override
  String get loading => '読み込み中...';

  @override
  String get errorOccurred => 'エラーが発生しました';

  @override
  String entriesCount(num count) {
    return '$count件のエントリー';
  }

  @override
  String targetWithValue(Object value) {
    return '目標: $value';
  }

  @override
  String get setTarget => '目標を設定';

  @override
  String get setDailyTarget => '1日のカロリー目標を設定';

  @override
  String todayWithDate(Object date) {
    return '今日 - $date';
  }

  @override
  String get cal => 'cal';

  @override
  String get addFoodEntry => '食品エントリーを追加';

  @override
  String get foodName => '食品名';

  @override
  String get nutritionDetailsOptional => '栄養詳細（任意）';

  @override
  String get nutritionEditLater => 'これらは後で食品ライブラリーで編集できます';

  @override
  String get addQuickEntry => 'クイック入力を追加';

  @override
  String get quantity => '数量';

  @override
  String get unit => '単位';

  @override
  String get items => '個';

  @override
  String get add => '追加';

  @override
  String get saveToLibrary => 'ライブラリーに保存？';

  @override
  String saveToLibraryPrompt(String name) {
    return '今後の使用のために「$name」を食品ライブラリーに保存しますか？';
  }

  @override
  String get noJustAddToday => 'いいえ、今日だけ追加';

  @override
  String get yesSaveToLibrary => 'はい、ライブラリーに保存';

  @override
  String addFoodTitle(String foodName) {
    return '$foodNameを追加';
  }

  @override
  String addMealTitle(String mealName) {
    return '$mealNameを追加';
  }

  @override
  String get servingsHelperText => '1.0 = 完全な食事、0.5 = 半分の食事';

  @override
  String addedFoodToLog(String foodName) {
    return '$foodNameを今日のログに追加しました';
  }

  @override
  String addedMealToLog(String mealName) {
    return '$mealNameを今日のログに追加しました';
  }

  @override
  String savedToLibraryAndAdded(String name) {
    return '$nameをライブラリーに保存し、今日のログに追加しました';
  }

  @override
  String addedWithCalories(String name, int calories) {
    return '$name（$calories cal）を今日のログに追加しました';
  }

  @override
  String get editInLibrary => 'ライブラリーで編集';

  @override
  String get noFoodsFound => '食品が見つかりません';

  @override
  String get noMealsFound => '食事が見つかりません';

  @override
  String ingredientsCount(int count) {
    return '$count個の材料';
  }

  @override
  String get hintZero => '0';

  @override
  String fieldRequired(String field) {
    return '$fieldは必須です';
  }

  @override
  String get quickEntryLower => 'クイック入力';

  @override
  String get bmiCalculator => 'BMI計算機';

  @override
  String get bodyMassIndex => '体格指数';

  @override
  String get weight => '体重';

  @override
  String get height => '身長';

  @override
  String get yourBmiResult => 'あなたのBMI結果';

  @override
  String get calculateBmi => 'BMIを計算';

  @override
  String get bmiCategories => 'BMIカテゴリー';

  @override
  String get underweight => '低体重';

  @override
  String get normalWeight => '標準体重';

  @override
  String get overweight => '過体重';

  @override
  String get obese => '肥満';

  @override
  String get required => '必須';

  @override
  String get invalid => '無効';

  @override
  String get bodyFatCalculator => '体脂肪計算機';

  @override
  String get estimateBodyFatPercentage => '体脂肪率を推定（米国海軍式）';

  @override
  String get age => '年齢';

  @override
  String get years => '歳';

  @override
  String get gender => '性別';

  @override
  String get male => '男性';

  @override
  String get female => '女性';

  @override
  String get neck => '首';

  @override
  String get waist => 'ウエスト';

  @override
  String get hip => 'ヒップ';

  @override
  String get bodyMeasurements => '身体測定';

  @override
  String get measurementInstructions => '測定方法';

  @override
  String get calculateBodyFat => '体脂肪を計算';

  @override
  String get bodyFatCategories => '体脂肪カテゴリー';

  @override
  String get bodyFatCategoriesMen => '体脂肪カテゴリー（男性）';

  @override
  String get bodyFatCategoriesWomen => '体脂肪カテゴリー（女性）';

  @override
  String get essentialFat => '必須脂肪';

  @override
  String get athletes => 'アスリート';

  @override
  String get fitness => 'フィットネス';

  @override
  String get average => '平均';

  @override
  String get yourBodyFatResult => 'あなたの体脂肪結果';

  @override
  String get neckMeasurementTip => '• 首：のどぼとけの下を測定';

  @override
  String get waistMeasurementTip => '• ウエスト：最も細い部分を測定';

  @override
  String get hipMeasurementTip => '• ヒップ：最も広い部分を測定';

  @override
  String get measurementAccuracyTip => '• 正確性のため、衣服を着用せずに測定';

  @override
  String get hipMeasurementRequired => '女性にはヒップの測定が必要です';

  @override
  String get usNavyMethod => '米国海軍式';

  @override
  String get usNavyDesc => '米国海軍によって開発されたこの方法は、身体の周囲測定を使用して体脂肪を推定します。結果は推定値であり、他の方法とは異なる場合があります。';

  @override
  String get idealWeightCalculator => '理想体重計算機';

  @override
  String get findIdealWeightRange => '理想体重範囲を見つける（ロビンソン公式）';

  @override
  String get calculateIdealWeight => '理想体重を計算';

  @override
  String get yourIdealWeight => 'あなたの理想体重';

  @override
  String get idealWeight => '理想体重';

  @override
  String get healthyWeightRange => '健康的な体重範囲';

  @override
  String get rangeBasedOnIdealWeight => '理想体重から±5kgの範囲に基づく';

  @override
  String currentWeight(String weight) {
    return '現在の体重: ${weight}kg';
  }

  @override
  String get withinIdealRange => '理想範囲内';

  @override
  String aboveIdeal(String difference) {
    return '理想より${difference}kg上';
  }

  @override
  String belowIdeal(String difference) {
    return '理想より${difference}kg下';
  }

  @override
  String get robinsonFormula => 'ロビンソン公式';

  @override
  String get robinsonFormulaMen => '男性: 52kg + 5フィート超過1インチごとに1.9kg';

  @override
  String get robinsonFormulaWomen => '女性: 49kg + 5フィート超過1インチごとに1.7kg';

  @override
  String get tdeeCalculator => 'TDEE計算機';

  @override
  String get totalDailyEnergyExpenditure => '総日常エネルギー消費量';

  @override
  String get activityLevel => '活動レベル';

  @override
  String get calculateTdee => 'TDEEを計算';

  @override
  String get yourTdeeResult => 'あなたのTDEE結果';

  @override
  String get tdeeMaintenanceDescription => 'これは現在の体重を維持するための推定日常カロリー必要量です。';

  @override
  String get setAsDailyCalorieTarget => '1日のカロリー目標として設定';

  @override
  String dailyCalorieTargetUpdatedTo(int calories) {
    return '1日のカロリー目標を$caloriesカロリーに更新しました';
  }

  @override
  String get sedentaryNoExercise => '座位中心（運動なし）';

  @override
  String get lightOneToTwoDays => '軽度（週1-2日）';

  @override
  String get lightTwoToThreeDays => '軽度（週2-3日）';

  @override
  String get moderateThreeToFourDays => '中程度（週3-4日）';

  @override
  String get moderateFourToFiveDays => '中程度（週4-5日）';

  @override
  String get activeSixToSevenDays => '活発（週6-7日）';

  @override
  String get veryActiveTwiceDaily => '非常に活発（1日2回）';

  @override
  String get extremelyActivePhysicalJob => '極度（肉体労働）';

  @override
  String get healthAndFitnessCalculators => '健康・フィットネス計算機';

  @override
  String get calculateImportantHealthMetrics => '重要な健康指標を計算';

  @override
  String get tdeeCalculatorDescription => '1日のカロリー必要量を計算';

  @override
  String get bmiCalculatorDescription => '体格指数を計算';

  @override
  String get idealWeightCalculatorDescription => '理想体重範囲を見つける';

  @override
  String get bodyFatCalculatorDescription => '体脂肪率を推定';

  @override
  String get monday => '月';

  @override
  String get tuesday => '火';

  @override
  String get wednesday => '水';

  @override
  String get thursday => '木';

  @override
  String get friday => '金';

  @override
  String get saturday => '土';

  @override
  String get sunday => '日';

  @override
  String get january => '1月';

  @override
  String get february => '2月';

  @override
  String get march => '3月';

  @override
  String get april => '4月';

  @override
  String get may => '5月';

  @override
  String get june => '6月';

  @override
  String get july => '7月';

  @override
  String get august => '8月';

  @override
  String get september => '9月';

  @override
  String get october => '10月';

  @override
  String get november => '11月';

  @override
  String get december => '12月';

  @override
  String get sevenDays => '7日間';

  @override
  String get thisWeek => '今週';

  @override
  String get thirtyDays => '30日間';

  @override
  String get noDataAvailable => 'データがありません';

  @override
  String get kcal => 'kcal';

  @override
  String get selectDateToViewDetails => '詳細を表示する日付を選択';

  @override
  String get tapOnAnyDayInCalendar => '上のカレンダーの任意の日をタップ';

  @override
  String get noEntriesYet => 'まだエントリーがありません';

  @override
  String get addEntry => '追加';

  @override
  String get entriesLogged => '件のエントリーが記録済み';

  @override
  String get foodLog => '食事ログ';

  @override
  String get quickCalorieEntry => 'クイックカロリー入力';

  @override
  String get nameRequired => '名前が必要です';

  @override
  String get foodNameHint => '例：鶏胸肉';

  @override
  String noJustAddToDate(String date) {
    return 'いいえ、$dateにのみ追加';
  }

  @override
  String addEntryForDate(String date) {
    return '追加 - $date';
  }

  @override
  String get statistics => '統計';

  @override
  String get deleteEntry => 'エントリーを削除';

  @override
  String get confirmDeleteEntry => 'このエントリーを削除してもよろしいですか？';

  @override
  String get entryDeletedSuccessfully => 'エントリーを正常に削除しました';

  @override
  String errorDeletingEntry(String error) {
    return 'エントリーの削除エラー: $error';
  }

  @override
  String get perItem => '1個あたり';

  @override
  String get perServing => '1人分あたり';

  @override
  String get per100g => '100gあたり';

  @override
  String get editFood => '食品を編集';

  @override
  String get addNewFood => '新しい食品を追加';

  @override
  String get basicInformation => '基本情報';

  @override
  String get descriptionOptional => '説明（任意）';

  @override
  String get briefDescription => '食品の簡単な説明';

  @override
  String get servingSize => '1人分のサイズ';

  @override
  String get servingSizeHint => '例：1カップ、2切れ';

  @override
  String get servingSizeRequired => '1人分のサイズは必須です';

  @override
  String get weightOptional => '重量（任意）';

  @override
  String get weightInGrams => 'グラム単位の重量';

  @override
  String get additionalNutrients => '追加栄養素';

  @override
  String get nutrientName => '栄養素名';

  @override
  String get nutrientNameHint => '例：食物繊維、ナトリウム';

  @override
  String get amount => '量';

  @override
  String get value => '値';

  @override
  String get enterAmount => '量を入力';

  @override
  String get valueRequired => '値が必要です';

  @override
  String get updateFood => '食品を更新';

  @override
  String get saveFood => '食品を保存';

  @override
  String get photoOptional => '写真（任意）';

  @override
  String get tapToAdd => 'タップして写真を追加';

  @override
  String get selectImageSource => '画像ソースを選択';

  @override
  String get camera => 'カメラ';

  @override
  String get gallery => 'ギャラリー';

  @override
  String get enterValidNumber => '有効な数値を入力してください';

  @override
  String get noFoodsYet => 'まだライブラリーに食品がありません';

  @override
  String get addFirstFood => '最初の食品を追加して開始';

  @override
  String get tryDifferentSearch => '別の検索用語を試してください';

  @override
  String get change => '変更';

  @override
  String get remove => '削除';

  @override
  String get standardNutritionInfo => '100gあたりの標準栄養情報';

  @override
  String get itemNutritionInfo => '卵、パンのスライスなどの食品用';

  @override
  String get servingNutritionInfo => '米国式サービングサイズ（例：1カップ、2切れ）';

  @override
  String get deleteFood => '食品を削除';

  @override
  String deleteFoodConfirmation(Object name) {
    return '「$name」を削除してもよろしいですか？この操作は元に戻せません。';
  }

  @override
  String get nutritionFacts => '栄養成分';

  @override
  String nutritionFactsPer(Object unit) {
    return '栄養成分（$unit）';
  }

  @override
  String get usageStats => '使用統計';

  @override
  String get created => '作成日';

  @override
  String get lastUsed => '最終使用日';

  @override
  String get timesUsed => '使用回数';

  @override
  String totalWeight(int weight) {
    return '総重量: ${weight}g';
  }

  @override
  String get foodDeleted => '食品を正常に削除しました';

  @override
  String unitWeight(Object weight) {
    return '単位重量: （$weight）g';
  }

  @override
  String get noFoodInLib => 'まだライブラリーに食品がありません';

  @override
  String get noFoodMatch => '検索に一致する食品がありません';

  @override
  String get tapAddFood => '+ ボタンをタップして最初の食品を追加';

  @override
  String get trySearchTerm => '別の検索用語を試してください';

  @override
  String totalWeightShort(Object weight) {
    return '${weight}g 合計';
  }

  @override
  String get editMeal => '食事を編集';

  @override
  String get createNewMeal => '新しい食事を作成';

  @override
  String get mealName => '食事名';

  @override
  String get mealNameHint => '例：鶏肉＆ライスボウル';

  @override
  String get mealDescHint => '高タンパク食事';

  @override
  String get category => 'カテゴリー';

  @override
  String get categoryHint => '昼食';

  @override
  String ingredients(int count) {
    return '食材 ($count)';
  }

  @override
  String get noIngredientsYet => 'まだ食材が追加されていません';

  @override
  String get tapAddIngredientHint => '「食材を追加」をタップして食事の作成を開始';

  @override
  String get pleaseAddOneIngredient => '少なくとも1つの食材を追加してください';

  @override
  String get saveMeal => '食事を保存';

  @override
  String get updateMeal => '食事を更新';

  @override
  String get nutritionSummary => '栄養概要';

  @override
  String get addIngredient => '食材を追加';

  @override
  String selectedFood(String foodName) {
    return '選択済み: $foodName';
  }

  @override
  String nutritionFor(String quantity) {
    return '$quantityの栄養:';
  }

  @override
  String get favorite => 'お気に入り';

  @override
  String get nutritionFactsTotal => '栄養成分（合計）';

  @override
  String get usageStatistics => '使用統計';

  @override
  String get deleteMeal => '食事を削除';

  @override
  String deleteMealConfirmation(String mealName) {
    return '「$mealName」を削除してもよろしいですか？この操作は元に戻せません。';
  }

  @override
  String get addedToFavorites => 'お気に入りに追加しました';

  @override
  String get removedFromFavorites => 'お気に入りから削除しました';

  @override
  String get missingFood => '食品項目が見つかりません';

  @override
  String foodId(String id) {
    return '食品ID: $id';
  }

  @override
  String get noMealsInLibrary => 'まだライブラリーに食事がありません';

  @override
  String get noMealsMatchSearch => '検索に一致する食事がありません';

  @override
  String get tapPlusButtonCreateMeal => '+ ボタンをタップして最初の食事を作成';

  @override
  String ingredientsWithTotal(int count, int weight) {
    return '$count個の食材 • 合計${weight}g';
  }

  @override
  String perServings(String serving) {
    return '$servingあたり';
  }
}
