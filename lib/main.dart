import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nibble/data/services/server_api_service.dart';
import 'package:nibble/shared/widgets/access_control_wrapper.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/main_screen.dart';
import 'data/services/food_database_service.dart';
import 'data/services/user_settings_service.dart';
import 'data/services/daily_tracking_service.dart';
import 'data/services/user_status_service.dart';
import 'data/services/access_control_service.dart';
import 'package:nibble/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  // Initialize Hive
  await Hive.initFlutter();

  // TEMPORARY: Reset user status for testing
  try {
    await Hive.deleteBoxFromDisk('user_status_encrypted');
    print('✅ User status reset for testing');
  } catch (e) {
    print('Reset error: $e');
  }

  // Initialize services
  await ServerApiService.init();
  await FoodDatabaseService.init();
  await UserSettingsService.init();
  await DailyTrackingService.init();
  await UserStatusService.initializeWithServer();
  await AccessControlService.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // localization support
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), // English
          Locale('ja'),
          // Add more languages as needed
        ],
        home: FutureBuilder(
          future: _initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.blue),
                      SizedBox(height: 16),
                      Text('Loading...'),
                    ],
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')),
              );
            }

            return AccessControlWrapper(child: MainScreen());
          },
        ),
      ),
    );
  }

  Future<void> _initializeApp() async {
    await Future.delayed(Duration(milliseconds: 100));
    await AccessControlService.initialize();
  }
}
