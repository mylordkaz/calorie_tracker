import 'package:flutter/material.dart';
import '../../data/services/access_control_service.dart';
import 'localization_helper.dart';

class TrialStatusHelper {
  static const int _warningDaysBeforeExpiry = 3;

  /// Get localized trial status message
  static String getStatusMessage(BuildContext context, TrialStatusData data) {
    final l10n = L10n.of(context);

    if (data.hasPurchased) {
      return l10n.accessControlFullAccessPurchased;
    }

    if (data.isPromoUser) {
      return l10n.accessControlPromoActive;
    }

    if (!data.hasTrialStarted) {
      return l10n.accessControlTrialAvailable;
    }

    if (data.isTrialActive) {
      final days = data.daysRemaining;
      if (days == 1) {
        return l10n.accessControlTrialExpiresToday;
      } else if (days <= _warningDaysBeforeExpiry) {
        return l10n.accessControlTrialExpiresIn(days);
      } else {
        return l10n.accessControlDaysRemaining(days);
      }
    }

    return l10n.accessControlTrialExpired;
  }
}
