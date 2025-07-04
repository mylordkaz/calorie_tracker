import 'food_repository.dart';
import 'food_repository_impl.dart';
import 'tracking_repository.dart';
import 'tracking_repository_impl.dart';
import 'settings_repository.dart';
import 'settings_repository_impl.dart';

class RepositoryFactory {
  static FoodRepository createFoodRepository() {
    return FoodRepositoryImpl();
  }

  static TrackingRepository createTrackingRepository() {
    return TrackingRepositoryImpl();
  }

  static SettingsRepository createSettingsRepository() {
    return SettingsRepositoryImpl();
  }
}
