import 'package:flutter_test/flutter_test.dart';
import 'package:nibble/data/models/user_status.dart';

void main() {
  group('Trial functionality test', () {
    test('New user has no trial', () {
      final user = UserStatus(
        userHash: 'user1',
        hasTrialStarted: false,
        hasPurchased: false,
        isPromoUser: false,
        lastUpdated: DateTime.now(),
      );

      expect(user.hasTrialStarted, false);
      expect(user.isTrialActive, false);
      expect(user.isTrialExpired, false);
      expect(user.daysRemainingInTrial, 0);
    });

    test('Active trial gives access', () {
      final now = DateTime.now();
      final user = UserStatus(
        userHash: 'user2',
        hasTrialStarted: true,
        trialStartDate: now,
        trialEndDate: now.add(Duration(days: 14)),
        hasPurchased: false,
        isPromoUser: false,
        lastUpdated: now,
      );

      expect(user.hasTrialStarted, true);
      expect(user.isTrialActive, true);
      expect(user.isTrialExpired, false);
      expect(user.daysRemainingInTrial, 14);
    });

    test('Expired trial blocks access', () {
      final now = DateTime.now();
      final user = UserStatus(
        userHash: 'user3',
        hasTrialStarted: true,
        trialStartDate: now.subtract(Duration(days: 20)),
        trialEndDate: now.subtract(Duration(days: 5)),
        hasPurchased: false,
        isPromoUser: false,
        lastUpdated: now,
      );

      expect(user.hasTrialStarted, true);
      expect(user.isTrialActive, false);
      expect(user.isTrialExpired, true);
      expect(user.daysRemainingInTrial, 0);
    });

    test('Trial expiring in 3 days', () {
      final now = DateTime.now();
      final user = UserStatus(
        userHash: 'user4',
        hasTrialStarted: true,
        trialStartDate: now.subtract(Duration(days: 11)),
        trialEndDate: now.add(Duration(days: 3)),
        hasPurchased: false,
        isPromoUser: false,
        lastUpdated: now,
      );

      expect(user.isTrialActive, true);
      expect(user.daysRemainingInTrial, 3);
    });

    test('Trial expiring in 1 hour still counts as 1 day', () {
      final now = DateTime.now();
      final user = UserStatus(
        userHash: 'user5',
        hasTrialStarted: true,
        trialStartDate: now.subtract(Duration(days: 13)),
        trialEndDate: now.add(Duration(hours: 6)),
        hasPurchased: false,
        isPromoUser: false,
        lastUpdated: now,
      );

      expect(user.isTrialActive, true);
      expect(user.daysRemainingInTrial, 1);
    });

    test('Trial without end date is not active', () {
      final now = DateTime.now();
      final user = UserStatus(
        userHash: 'user6',
        hasTrialStarted: true,
        trialStartDate: now,
        // trialEndDate: null
        hasPurchased: false,
        isPromoUser: false,
        lastUpdated: now,
      );

      expect(user.hasTrialStarted, true);
      expect(user.isTrialActive, false);
      expect(user.daysRemainingInTrial, 0);
    });

    test('Start trial using copyWith', () {
      final now = DateTime.now();
      final newUser = UserStatus(
        userHash: 'user7',
        hasTrialStarted: false,
        hasPurchased: false,
        isPromoUser: false,
        lastUpdated: now,
      );

      final trialUser = newUser.copyWith(
        hasTrialStarted: true,
        trialStartDate: now,
        trialEndDate: now.add(Duration(days: 14)),
      );

      expect(newUser.hasTrialStarted, false);
      expect(trialUser.hasTrialStarted, true);
      expect(trialUser.isTrialActive, true);
      expect(trialUser.daysRemainingInTrial, 14);
    });

    test('14 day trial calculation', () {
      final now = DateTime.now();
      final user = UserStatus(
        userHash: 'user8',
        hasTrialStarted: true,
        trialStartDate: now,
        trialEndDate: now.add(Duration(days: 14)),
        hasPurchased: false,
        isPromoUser: false,
        lastUpdated: now,
      );

      expect(user.daysRemainingInTrial, 14);
    });

    test('Trial expired 1 second ago', () {
      final now = DateTime.now();
      final user = UserStatus(
        userHash: 'user9',
        hasTrialStarted: true,
        trialStartDate: now.subtract(Duration(days: 14)),
        trialEndDate: now.subtract(Duration(seconds: 1)),
        hasPurchased: false,
        isPromoUser: false,
        lastUpdated: now,
      );

      expect(user.isTrialActive, false);
      expect(user.isTrialExpired, true);
    });

    test('Trial expires in 1 second', () {
      final now = DateTime.now();
      final user = UserStatus(
        userHash: 'user10',
        hasTrialStarted: true,
        trialStartDate: now.subtract(Duration(days: 13)),
        trialEndDate: now.add(Duration(seconds: 1)),
        hasPurchased: false,
        isPromoUser: false,
        lastUpdated: now,
      );

      expect(user.isTrialActive, true);
      expect(user.isTrialExpired, false);
    });
  });
}
