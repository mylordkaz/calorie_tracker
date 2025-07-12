import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../models/user_status.dart';
import 'user_identification_service.dart';

class UserStatusService {
  static const String _statusBoxName = 'user_status_encrypted';
  static const String _statusKey = 'user_status_data';
  static const int _trialDurationDays = 14;

  static Box<UserStatus>? _statusBox;
  static Uint8List? _encryptionKey;

  // initialize service
  static Future<void> init() async {
    // register adapter
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(UserStatusAdapter());
    }

    // generate encryption key from user hash
    await _generateEncryptionKey();

    try {
      _statusBox = await Hive.openBox<UserStatus>(
        _statusBoxName,
        encryptionCipher: HiveAesCipher(_encryptionKey!),
      );
    } catch (e) {
      print('Error opening encrypted status box, clearing data: $e');
      await Hive.deleteBoxFromDisk(_statusBoxName);
      _statusBox = await Hive.openBox<UserStatus>(
        _statusBoxName,
        encryptionCipher: HiveAesCipher(_encryptionKey!),
      );
    }

    // validate stored data integrity
    await _validateStoredData();
  }

  static Box<UserStatus> get _box {
    if (_statusBox == null) {
      throw Exception('UserStatusService not initialize. Call init() first.');
    }
    return _statusBox!;
  }

  // generate encryption key fron user hash for data protection
  static Future<void> _generateEncryptionKey() async {
    final userHash = await UserIdentificationService.generateUserHash();
    final keyMaterial = '$userHash-nibble-encryption-salt';
    final bytes = utf8.encode(keyMaterial);
    final digest = sha256.convert(bytes);
    _encryptionKey = Uint8List.fromList(digest.bytes);
  }

  // validate that stored data hasn't been tampered with
  static Future<void> _validateStoredData() async {
    final status = _box.get(_statusKey);
    if (status != null) {
      final isValid = await UserIdentificationService.validateUserHash(
        status.userHash,
      );
      if (!isValid) {
        print('Data tampering detected, clearing user status');
        await _box.clear();
      }
    }
  }

  // get current user status - create if new
  static Future<UserStatus> getUserStatus() async {
    UserStatus? status = _box.get(_statusKey);

    if (status == null) {
      final userHash = await UserIdentificationService.generateUserHash();
      status = UserStatus(userHash: userHash, lastUpdated: DateTime.now());
      await _box.put(_statusKey, status);
    }
    return status;
  }

  // start trial for new user
  static Future<bool> startTrial() async {
    final status = await getUserStatus();
    if (status.hasTrialStarted) {
      return false;
    }

    final now = DateTime.now();
    final updatedStatus = status.copyWith(
      hasTrialStarted: true,
      trialStartDate: now,
      trialEndDate: now.add(Duration(days: _trialDurationDays)),
      lastUpdated: now,
    );

    await _box.put(_statusKey, updatedStatus);
    return true;
  }

  // check user: trial active, pruchased or promo
  static Future<bool> hasAccess() async {
    final status = await getUserStatus();
    return status.hasAccess;
  }

  // check if trial active
  static Future<bool> isTrialActive() async {
    final status = await getUserStatus();
    return status.isTrialActive;
  }

  // check trial expired
  static Future<bool> isTrialExpired() async {
    final status = await getUserStatus();
    return status.isTrialExpired;
  }

  // get remaining trial days
  static Future<int> getDaysRemainingInTrial() async {
    final status = await getUserStatus();
    return status.daysRemainingInTrial;
  }

  // mark user as purchased
  static Future<void> markAsPurchased({
    required String purchaseToken,
    DateTime? purchaseDate,
  }) async {
    final status = await getUserStatus();
    final updatedStatus = status.copyWith(
      hasPurchased: true,
      purchaseToken: purchaseToken,
      purchaseDate: purchaseDate ?? DateTime.now(),
      lastUpdated: DateTime.now(),
    );
    await _box.put(_statusKey, updatedStatus);
  }

  // promo code
  static Future<void> redeemPromoCode(String promoCode) async {
    final status = await getUserStatus();
    final updatedStatus = status.copyWith(
      isPromoUser: true,
      promoCode: promoCode,
      lastUpdated: DateTime.now(),
    );

    await _box.put(_statusKey, updatedStatus);
  }

  // get current status (debug/display)
  static Future<Map<String, dynamic>> getStatusInfo() async {
    final status = await getUserStatus();
    return {
      'hasTrialStarted': status.hasTrialStarted,
      'isTrialActive': status.isTrialActive,
      'isTrialExpired': status.isTrialExpired,
      'daysRemaining': status.daysRemainingInTrial,
      'hasPurchased': status.hasPurchased,
      'isPromoUser': status.isPromoUser,
      'hasAccess': status.hasAccess,
      'trialStartDate': status.trialStartDate?.toIso8601String(),
      'trialEndDate': status.trialEndDate?.toIso8601String(),
      'lastUpdated': status.lastUpdated.toIso8601String(),
    };
  }

  // update last access timestamp
  static Future<void> touch() async {
    final status = await getUserStatus();
    status.touch();
    await _box.put(_statusKey, status);
  }

  // check new user (bo trial started)
  static Future<bool> isNewUser() async {
    final status = await getUserStatus();
    return !status.hasTrialStarted &&
        !status.hasPurchased &&
        !status.isPromoUser;
  }

  // reset all data (REMOVE FOR PRODUCTION)
  static Future<void> resetAllData() async {
    assert(() {
      return true;
    }());
    await _box.clear();
  }

  // validate data integrity
  static Future<bool> validateDataIntegrity() async {
    try {
      final status = await getUserStatus();
      return await UserIdentificationService.validateUserHash(status.userHash);
    } catch (e) {
      return false;
    }
  }
}
