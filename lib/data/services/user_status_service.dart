import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../models/user_status.dart';
import 'user_identification_service.dart';
import 'server_api_service.dart';
import 'dart:io';

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
  static Future<bool> startTrialWithServer() async {
    try {
      final status = await getUserStatus();
      final userHash = status.userHash;

      // Check server first
      try {
        final serverResponse = await ServerApiService.startTrial(userHash);
        if (serverResponse['success'] == true) {
          // Update local status with server data
          final trialStartedAt = DateTime.fromMillisecondsSinceEpoch(
            serverResponse['trial_started_at'] * 1000,
          );
          final trialExpiresAt = DateTime.fromMillisecondsSinceEpoch(
            serverResponse['trial_expires_at'] * 1000,
          );

          final updatedStatus = status.copyWith(
            hasTrialStarted: true,
            trialStartDate: trialStartedAt,
            trialEndDate: trialExpiresAt,
            lastUpdated: DateTime.now(),
          );

          await _box.put(_statusKey, updatedStatus);
          print('✅ Trial started via server');
          return true;
        }
        return false;
      } catch (e) {
        print('⚠️ Server trial start failed, trying local: $e');

        // Fallback to local trial start if server fails
        if (status.hasTrialStarted) {
          return false; // Already started locally
        }

        // Start trial locally as fallback
        final now = DateTime.now();
        final updatedStatus = status.copyWith(
          hasTrialStarted: true,
          trialStartDate: now,
          trialEndDate: now.add(Duration(days: _trialDurationDays)),
          lastUpdated: now,
        );

        await _box.put(_statusKey, updatedStatus);

        // Try to sync with server in background
        syncWithServer().catchError((e) => print('Background sync failed: $e'));

        print('✅ Trial started locally (offline mode)');
        return true;
      }
    } catch (e) {
      print('❌ Error starting trial: $e');
      return false;
    }
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
  static Future<void> markAsPurchasedWithServer({
    required String purchaseToken,
    DateTime? purchaseDate,
  }) async {
    try {
      final status = await getUserStatus();
      final userHash = status.userHash;

      // Update locally first for immediate response
      final updatedStatus = status.copyWith(
        hasPurchased: true,
        purchaseToken: purchaseToken,
        purchaseDate: purchaseDate ?? DateTime.now(),
        lastUpdated: DateTime.now(),
      );
      await _box.put(_statusKey, updatedStatus);
      print('✅ Purchase marked locally');

      // Sync with server
      try {
        await ServerApiService.validatePurchase(
          userHash: userHash,
          purchaseToken: purchaseToken,
          platform: Platform.isIOS ? 'apple' : 'google',
        );
        print('✅ Purchase validated with server');
      } catch (e) {
        print('⚠️ Server purchase validation failed (continuing locally): $e');
        // Continue with local purchase - server will sync later
      }
    } catch (e) {
      print('❌ Error marking as purchased: $e');
    }
  }

  // Enhanced redeemPromoCode method with server validation
  static Future<void> redeemPromoCodeWithServer(String promoCode) async {
  try {
    final status = await getUserStatus();
    final userHash = status.userHash;

    // Try server first
    try {
      final response = await ServerApiService.redeemPromoCode(
        userHash: userHash,
        promoCode: promoCode,
      );

      if (response['success'] == true) {
        // Update local status
        final updatedStatus = status.copyWith(
          isPromoUser: true,
          promoCode: promoCode,
          lastUpdated: DateTime.now(),
        );
        await _box.put(_statusKey, updatedStatus);
        print('✅ Promo code redeemed via server');
        return;
      } else {
        throw Exception(response['error'] ?? 'Failed to redeem promo code');
      }
    } catch (e) {
      print('⚠️ Server promo redemption failed, trying local: $e');
      
      // Local fallback for offline users
      // Note: This allows offline redemption but server will validate later
      final updatedStatus = status.copyWith(
        isPromoUser: true,
        promoCode: promoCode,
        lastUpdated: DateTime.now(),
      );
      await _box.put(_statusKey, updatedStatus);
      
      // Try to sync with server in background
      syncWithServer().catchError((e) => print('Background sync failed: $e'));
      
      print('✅ Promo code redeemed locally (offline mode)');
    }
  } catch (e) {
    print('❌ Error redeeming promo code: $e');
    throw Exception('Error redeeming promo code: $e');
  }
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

  // Sync local data with server
  static Future<void> syncWithServer() async {
    try {
      UserStatus status = await getUserStatus();
      final userHash = status.userHash;

      final serverStatus = await ServerApiService.getUserStatus(userHash);

      // Update local status based on server response
      bool needsUpdate = false;

      if (serverStatus['is_purchased'] == true && !status.hasPurchased) {
				status = status.copyWith(
					hasPurchased: true,
					purchaseToken: 'server_validated',
					purchaseDate: DateTime.now(),
				);
				needsUpdate = true;
			}

      if (serverStatus['trial_active'] == true &&
          serverStatus['trial_expires_at'] != null) {
        final trialExpiresAt = DateTime.fromMillisecondsSinceEpoch(
          serverStatus['trial_expires_at'] * 1000,
        );
        final trialStartedAt = trialExpiresAt.subtract(
          Duration(days: _trialDurationDays),
        );

        if (!status.hasTrialStarted || status.trialEndDate != trialExpiresAt) {
          status = status.copyWith(
						hasTrialStarted: true,
						trialStartDate: trialStartedAt,
						trialEndDate: trialExpiresAt,
					);
          needsUpdate = true;
        }
      }

      if (needsUpdate) {
        status = status.copyWith(lastUpdated: DateTime.now());
        await _box.put(_statusKey, status);
        print('✅ Synced with server');
      }
    } catch (e) {
      print('⚠️ Server sync failed (continuing offline): $e');
      // Continue with local data - offline support
    }
  }

  // Initialize with server sync
  static Future<void> initializeWithServer() async {
    await init(); // Call existing init first
    await syncWithServer(); // Then sync with server
  }
}
