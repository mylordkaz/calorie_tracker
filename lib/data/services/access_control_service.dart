import 'user_status_service.dart';

enum AccessLevel { trial, purchased, promo, expired, newUser }

class TrialStatusData {
  final bool hasPurchased;
  final bool isPromoUser;
  final bool hasTrialStarted;
  final bool isTrialActive;
  final int daysRemaining;

  TrialStatusData({
    required this.hasPurchased,
    required this.isPromoUser,
    required this.hasTrialStarted,
    required this.isTrialActive,
    required this.daysRemaining,
  });
}

class AccessControlService {
  static const int _warningDaysBeforeExpiry = 3;

  // check current access lvl
  static Future<AccessLevel> getAccessLevel() async {
    final status = await UserStatusService.getUserStatus();

    if (status.hasPurchased) {
      return AccessLevel.purchased;
    }
    if (status.isPromoUser) {
      return AccessLevel.promo;
    }
    if (!status.hasTrialStarted) {
      return AccessLevel.newUser;
    }
    if (status.isTrialActive) {
      return AccessLevel.trial;
    }

    return AccessLevel.expired;
  }

  // check app access
  static Future<bool> canAccessApp() async {
    return await UserStatusService.hasAccess();
  }

  // check if trial warning needed
  static Future<bool> shouldShowTrialWarning() async {
    final status = await UserStatusService.getUserStatus();
    if (!status.isTrialActive) return false;

    return status.daysRemainingInTrial <= _warningDaysBeforeExpiry;
  }

  // get trial status message for UI
  static Future<TrialStatusData> getTrialStatusData() async {
    final status = await UserStatusService.getUserStatus();

    return TrialStatusData(
      hasPurchased: status.hasPurchased,
      isPromoUser: status.isPromoUser,
      hasTrialStarted: status.hasTrialStarted,
      isTrialActive: status.isTrialActive,
      daysRemaining: status.daysRemainingInTrial,
    );
  }

  // init access control
  static Future<void> initialize() async {
    await UserStatusService.touch();

    final isValid = await UserStatusService.validateDataIntegrity();
    if (!isValid) {
      print('Access control: Data integrity check failed');
    }
  }
}
