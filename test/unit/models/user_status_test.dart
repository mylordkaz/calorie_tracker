import 'package:flutter_test/flutter_test.dart';
import 'package:nibble/data/models/user_status.dart';

void main() {
  group('UserStatus Promo Code Tests', () {
    late UserStatus baseUserStatus;

    setUp(() {
      baseUserStatus = UserStatus(
        userHash: 'test_user_hash',
        lastUpdated: DateTime.now(),
      );
    });

    group('hasAccess property', () {
      test('should return true when user is promo user', () {
        // Arrange
        final promoUser = baseUserStatus.copyWith(
          isPromoUser: true,
          promoCode: 'TESTCODE123',
        );

        // Act & Assert
        expect(promoUser.hasAccess, isTrue);
      });

      test('should return true when user has purchased', () {
        // Arrange
        final purchasedUser = baseUserStatus.copyWith(hasPurchased: true);

        // Act & Assert
        expect(purchasedUser.hasAccess, isTrue);
      });

      test('should return true when trial is active', () {
        // Arrange
        final now = DateTime.now();
        final activeTrialUser = baseUserStatus.copyWith(
          hasTrialStarted: true,
          trialStartDate: now.subtract(Duration(days: 5)),
          trialEndDate: now.add(Duration(days: 9)),
        );

        // Act & Assert
        expect(activeTrialUser.hasAccess, isTrue);
      });

      test('should return false when user has no access', () {
        // Arrange
        final noAccessUser = baseUserStatus.copyWith(
          isPromoUser: false,
          hasPurchased: false,
          hasTrialStarted: false,
        );

        // Act & Assert
        expect(noAccessUser.hasAccess, isFalse);
      });
    });

    group('promo user specific behavior', () {
      test('should override trial logic when user is promo user', () {
        // Arrange
        final now = DateTime.now();
        final promoUserWithExpiredTrial = baseUserStatus.copyWith(
          hasTrialStarted: true,
          trialStartDate: now.subtract(Duration(days: 20)),
          trialEndDate: now.subtract(Duration(days: 6)),
          isPromoUser: true,
          promoCode: 'OVERRIDE123',
          hasPurchased: false,
        );

        // Act & Assert
        expect(promoUserWithExpiredTrial.hasAccess, isTrue);
        expect(promoUserWithExpiredTrial.isTrialActive, isFalse);
        expect(promoUserWithExpiredTrial.isTrialExpired, isFalse);
      });

      test('should return 0 trial days when user is promo user', () {
        // Arrange
        final now = DateTime.now();
        final promoUserWithActiveTrial = baseUserStatus.copyWith(
          hasTrialStarted: true,
          trialStartDate: now.subtract(Duration(days: 5)),
          trialEndDate: now.add(Duration(days: 9)),
          isPromoUser: true,
          promoCode: 'PROMODAYS123',
        );

        // Act & Assert
        expect(promoUserWithActiveTrial.daysRemainingInTrial, equals(0));
      });
    });

    group('copyWith method with promo fields', () {
      test('should copy promo fields correctly', () {
        // Arrange
        const originalPromoCode = 'ORIGINAL123';
        const newPromoCode = 'UPDATED456';

        final originalUser = baseUserStatus.copyWith(
          isPromoUser: true,
          promoCode: originalPromoCode,
        );

        // Act
        final updatedUser = originalUser.copyWith(promoCode: newPromoCode);

        // Assert
        expect(updatedUser.isPromoUser, isTrue);
        expect(updatedUser.promoCode, equals(newPromoCode));
        expect(
          originalUser.promoCode,
          equals(originalPromoCode),
        ); // Original unchanged
      });

      test('should preserve existing values when not explicitly set', () {
        // Arrange
        final promoUser = baseUserStatus.copyWith(
          isPromoUser: true,
          promoCode: 'TESTCODE123',
        );

        // Act
        final updatedUser = promoUser.copyWith(
          // Only update lastUpdated, leave promo fields as-is
          lastUpdated: DateTime.now(),
        );

        // Assert
        expect(updatedUser.isPromoUser, isTrue);
        expect(updatedUser.promoCode, equals('TESTCODE123'));
      });

      test('should explicitly clear promo fields when set to defaults', () {
        // Arrange
        final promoUser = baseUserStatus.copyWith(
          isPromoUser: true,
          promoCode: 'TESTCODE123',
        );

        // Act - explicitly setting new values
        final clearedUser = UserStatus(
          userHash: promoUser.userHash,
          lastUpdated: DateTime.now(),
          isPromoUser: false,
          promoCode: null,
        );

        // Assert
        expect(clearedUser.isPromoUser, isFalse);
        expect(clearedUser.promoCode, isNull);
      });
    });
  });
}
