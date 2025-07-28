import 'package:flutter/material.dart';
import '../../../data/services/export_service.dart';
import '../../../data/services/import_service.dart';

class ExportController extends ChangeNotifier {
  // Export state
  bool _isExportingFoods = false;
  bool _isExportingMeals = false;
  bool _isExportingCalendar = false;

  // Import state
  bool _isImportingFoods = false;
  bool _isImportingMeals = false;

  String? _exportError;
  String? _lastSuccessMessage;

  // Callbacks for refreshing UI after imports
  VoidCallback? _onFoodsUpdated;
  VoidCallback? _onMealsUpdated;

  void setRefreshCallbacks({
    VoidCallback? onFoodsUpdated,
    VoidCallback? onMealsUpdated,
  }) {
    _onFoodsUpdated = onFoodsUpdated;
    _onMealsUpdated = onMealsUpdated;
  }

  // Export getters
  bool get isExportingFoods => _isExportingFoods;
  bool get isExportingMeals => _isExportingMeals;
  bool get isExportingCalendar => _isExportingCalendar;
  bool get isExporting =>
      _isExportingFoods || _isExportingMeals || _isExportingCalendar;

  // Import getters
  bool get isImportingFoods => _isImportingFoods;
  bool get isImportingMeals => _isImportingMeals;
  bool get isImporting => _isImportingFoods || _isImportingMeals;

  // Combined getters
  bool get isBusy => isExporting || isImporting;
  String? get exportError => _exportError;
  String? get lastSuccessMessage => _lastSuccessMessage;

  // Export food library
  Future<void> exportFoodLibrary([String? successMessage]) async {
    try {
      _isExportingFoods = true;
      _exportError = null;
      _lastSuccessMessage = null;
      notifyListeners();

      await ExportService.exportFoodLibrary();
      _lastSuccessMessage =
          successMessage ?? 'Food library exported successfully!';
    } catch (e) {
      _exportError = e.toString();
    } finally {
      _isExportingFoods = false;
      notifyListeners();
    }
  }

  // Export meal library
  Future<void> exportMealLibrary([String? successMessage]) async {
    try {
      _isExportingMeals = true;
      _exportError = null;
      _lastSuccessMessage = null;
      notifyListeners();

      await ExportService.exportMealLibrary();
      _lastSuccessMessage =
          successMessage ?? 'Meal library exported successfully!';
    } catch (e) {
      _exportError = e.toString();
    } finally {
      _isExportingMeals = false;
      notifyListeners();
    }
  }

  // Export calendar data
  Future<void> exportCalendarData({
    DateTime? startDate,
    DateTime? endDate,
    String? successMessage,
  }) async {
    try {
      _isExportingCalendar = true;
      _exportError = null;
      _lastSuccessMessage = null;
      notifyListeners();

      await ExportService.exportCalendarData(
        startDate: startDate,
        endDate: endDate,
      );
      _lastSuccessMessage =
          successMessage ?? 'Calendar data exported successfully!';
    } catch (e) {
      _exportError = e.toString();
    } finally {
      _isExportingCalendar = false;
      notifyListeners();
    }
  }

  // Import food library
  Future<void> importFoodLibrary([String? successMessagePrefix]) async {
    try {
      _isImportingFoods = true;
      _exportError = null;
      _lastSuccessMessage = null;
      notifyListeners();

      final result = await ImportService.importFoodLibrary();

      if (result.success) {
        _lastSuccessMessage =
            '${successMessagePrefix ?? 'Food import completed'}: ${result.message}';
        _onFoodsUpdated?.call();
      } else {
        _exportError = result.message;
      }
    } catch (e) {
      _exportError = e.toString();
    } finally {
      _isImportingFoods = false;
      notifyListeners();
    }
  }

  // Import meal library
  Future<void> importMealLibrary([String? successMessagePrefix]) async {
    try {
      _isImportingMeals = true;
      _exportError = null;
      _lastSuccessMessage = null;
      notifyListeners();

      final result = await ImportService.importMealLibrary();

      if (result.success) {
        _lastSuccessMessage =
            '${successMessagePrefix ?? 'Meal import completed'}: ${result.message}';
        _onMealsUpdated?.call();
      } else {
        _exportError = result.message;
      }
    } catch (e) {
      _exportError = e.toString();
    } finally {
      _isImportingMeals = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _exportError = null;
    _lastSuccessMessage = null;
    notifyListeners();
  }
}
