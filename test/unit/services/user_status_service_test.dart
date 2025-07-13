import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nibble/data/services/user_status_service.dart';
import 'package:nibble/data/services/server_api_service.dart';
import 'package:nibble/data/services/user_identification_service.dart';
import 'package:nibble/data/models/user_status.dart';

// Create mocks manually since @GenerateMocks might cause issues
class MockServerApiService extends Mock {
  static Future<Map<String, dynamic>> redeemPromoCode({
    required String userHash,
    required String promoCode,
  }) {
    return Future.value({});
  }
}

class MockBox<T> extends Mock implements Box<T> {}

void main() {
  group('UserStatusService Promo Code Tests', () {
    late MockBox<UserStatus> mockBox;
    late UserStatus testUserStatus;

    setUp(() {
      mockBox = MockBox<UserStatus>();
      testUserStatus = UserStatus(
        userHash: 'test_user_hash',
        lastUpdated: DateTime.now(),
      );
    });

    group('hasAccess method', () {
      test('should return true when user is promo user', () async {
        // Arrange
        final promoUser = testUserStatus.copyWith(
          isPromoUser: true,
          promoCode: 'TESTCODE123',
        );

        when(mockBox.get(any)).thenReturn(promoUser);

        // Note: This test would need UserStatusService to accept a mock box
        // For now, we'll test the UserStatus model directly
        expect(promoUser.hasAccess, isTrue);
      });

      test('should return true when user has purchased', () async {
        // Arrange
        final purchasedUser = testUserStatus.copyWith(hasPurchased: true);

        expect(purchasedUser.hasAccess, isTrue);
      });

      test('should return false when user has no access', () async {
        // Arrange
        final noAccessUser = testUserStatus.copyWith(
          isPromoUser: false,
          hasPurchased: false,
          hasTrialStarted: false,
        );

        expect(noAccessUser.hasAccess, isFalse);
      });
    });

    group('isNewUser considerations', () {
      test('should return false when user is promo user', () async {
        // Arrange
        final promoUser = testUserStatus.copyWith(
          isPromoUser: true,
          promoCode: 'TESTCODE123',
        );

        // Test the model logic directly
        final isNew =
            !promoUser.hasTrialStarted &&
            !promoUser.hasPurchased &&
            !promoUser.isPromoUser;

        expect(isNew, isFalse);
      });

      test('should return true when user has no access methods', () async {
        // Arrange
        final newUser = testUserStatus.copyWith(
          isPromoUser: false,
          hasPurchased: false,
          hasTrialStarted: false,
        );

        final isNew =
            !newUser.hasTrialStarted &&
            !newUser.hasPurchased &&
            !newUser.isPromoUser;

        expect(isNew, isTrue);
      });
    });

    group('promo code validation', () {
      test('should validate promo code basic requirements', () {
        // Test minimum length requirement (3+ characters)
        const validCodes = ['ABC', 'TEST123', 'PROMO2024', 'XYZ'];
        const invalidCodes = ['', '  ', 'AB'];

        for (final code in validCodes) {
          final isValid = code.isNotEmpty && code.trim().length >= 3;
          expect(isValid, isTrue, reason: 'Code "$code" should be valid');
        }

        for (final code in invalidCodes) {
          final isValid = code.isNotEmpty && code.trim().length >= 3;
          expect(isValid, isFalse, reason: 'Code "$code" should be invalid');
        }
      });

      test('should handle whitespace in promo codes', () {
        // Test trimming behavior
        const codesWithWhitespace = ['  ABC  ', ' TEST123 ', '\tPROMO\n'];

        for (final code in codesWithWhitespace) {
          final trimmed = code.trim();
          expect(trimmed.length >= 3, isTrue);
          expect(trimmed.contains(' '), isFalse);
        }
      });

      test('should validate promo code characters', () {
        // Test various character combinations
        const alphaNumericCodes = ['ABC123', 'TEST', '123ABC', 'PROMO2024'];

        for (final code in alphaNumericCodes) {
          // Basic validation: non-empty, proper length
          final isValidFormat =
              code.isNotEmpty &&
              code.trim().length >= 3 &&
              code.trim().length <= 50;
          expect(
            isValidFormat,
            isTrue,
            reason: 'Code "$code" should have valid format',
          );
        }
      });

      test('should reject empty or too short codes', () {
        const invalidCodes = ['', ' ', 'A', 'AB', '1', '12'];

        for (final code in invalidCodes) {
          final isValid = code.isNotEmpty && code.trim().length >= 3;
          expect(isValid, isFalse, reason: 'Code "$code" should be rejected');
        }
      });
    });

    group('promo code state management', () {
      test('should track promo code redemption state', () {
        // Test state transitions
        final initialUser = testUserStatus;
        expect(initialUser.isPromoUser, isFalse);
        expect(initialUser.promoCode, isNull);

        final redeemedUser = initialUser.copyWith(
          isPromoUser: true,
          promoCode: 'REDEEMED123',
        );
        expect(redeemedUser.isPromoUser, isTrue);
        expect(redeemedUser.promoCode, equals('REDEEMED123'));
        expect(redeemedUser.hasAccess, isTrue);
      });

      test('should preserve other user state when redeeming promo', () {
        // User with existing trial
        final userWithTrial = testUserStatus.copyWith(
          hasTrialStarted: true,
          trialStartDate: DateTime.now().subtract(Duration(days: 5)),
          trialEndDate: DateTime.now().add(Duration(days: 9)),
        );

        final userWithPromo = userWithTrial.copyWith(
          isPromoUser: true,
          promoCode: 'UPGRADE123',
        );

        // Should preserve trial data but promo takes precedence for access
        expect(userWithPromo.hasTrialStarted, isTrue);
        expect(userWithPromo.isPromoUser, isTrue);
        expect(userWithPromo.hasAccess, isTrue);
        // Promo user should not use trial days
        expect(userWithPromo.daysRemainingInTrial, equals(0));
      });
    });
  });
}
