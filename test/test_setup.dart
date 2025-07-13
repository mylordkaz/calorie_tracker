import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nibble/data/models/user_status.dart';

Future<void> setupTestEnvironment() async {
  // Initialize Hive for testing
  await Hive.initFlutter();

  // Register adapters
  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(UserStatusAdapter());
  }
}

Future<void> cleanupTestEnvironment() async {
  // Clean up any open boxes
  await Hive.close();

  // Delete test data
  await Hive.deleteFromDisk();
}
