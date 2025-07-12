import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'dart:io';

class UserIdentificationService {
  static String? _cachedUserHash;
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // generate hash for current user
  static Future<String> generateUserHash() async {
    if (_cachedUserHash != null) {
      return _cachedUserHash!;
    }

    String identifier;

    if (Platform.isIOS) {
      identifier = await _getIOSIdentifier();
    } else if (Platform.isAndroid) {
      identifier = await _getAndroidIdentifier();
    } else {
      throw UnsupportedError('Platform not supported');
    }

    // Create SHA-256 hash
    final bytes = utf8.encode(identifier);
    final digest = sha256.convert(bytes);
    _cachedUserHash = digest.toString();

    return _cachedUserHash!;
  }

  // get IOS identifier - Apple ID first when available
  static Future<String> _getIOSIdentifier() async {
    try {
      if (await SignInWithApple.isAvailable()) {
        try {
          final credential = await SignInWithApple.getAppleIDCredential(
            scopes: [AppleIDAuthorizationScopes.email],
          );
          if (credential.userIdentifier != null) {
            return 'apple_${credential.userIdentifier}';
          }
        } catch (e) {
          // Apple Sign In failed, continue to fallback
          print('Apple Sign In failed: $e');
        }
      }

      // Fallback to iOS device identifier
      final iosInfo = await _deviceInfo.iosInfo;
      return 'ios_${iosInfo.identifierForVendor}';
    } catch (e) {
      print('Error getting iOS identifier: $e');
      // Last resort fallback
      final iosInfo = await _deviceInfo.iosInfo;
      return 'ios_fallback_${iosInfo.model}_${iosInfo.systemVersion}';
    }
  }

  // get Android identifier - Google account first when available
  static Future<String> _getAndroidIdentifier() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

      try {
        final GoogleSignInAccount? account = await googleSignIn
            .signInSilently();
        if (account != null && account.id.isNotEmpty) {
          return 'google_${account.id}';
        }
      } catch (e) {
        print('Google Sign In failed: $e');
      }

      // fallback to Android device identifier
      final androidInfo = await _deviceInfo.androidInfo;
      return 'android_${androidInfo.id}';
    } catch (e) {
      print('Error getting Android identifier: $e');

      final androidInfo = await _deviceInfo.androidInfo;
      return 'android_fallback_${androidInfo.model}_${androidInfo.brand}';
    }
  }

  // clear cached hash (testing purpose)
  // REMOVE for Production
  static void clearCache() {
    assert(() {
      _cachedUserHash = null;
      return true;
    }());
  }

  //validate, current hash = stored hash
  static Future<bool> validateUserHash(String storedHash) async {
    final currentHash = await generateUserHash();
    return currentHash == storedHash;
  }
}
