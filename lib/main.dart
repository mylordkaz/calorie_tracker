import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/main_screen.dart';
import 'services/food_database_service.dart';
import 'services/user_settings_service.dart';
import 'services/daily_tracking_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Clear settings box due to schema change (remove this line after first run)
  // await Hive.deleteBoxFromDisk('user_settings');

  // Initialize services
  await FoodDatabaseService.init();
  await UserSettingsService.init();
  await DailyTrackingService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Tracker',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: FutureBuilder(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.green),
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

          return MainScreen();
        },
      ),
    );
  }

  Future<void> _initializeApp() async {
    // Ensure all services are initialized
    await Future.delayed(Duration(milliseconds: 100));
  }
}
