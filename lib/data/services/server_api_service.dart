import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ServerApiService {
  static String get _baseUrl {
    final url = dotenv.env['WORKER_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('WORKER_URL not found in environment variables');
    }
    return url;
  }

  static const int _timeoutSeconds = 10;

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  static Future<Map<String, dynamic>> getUserStatus(String userHash) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/api/user/status?user_hash=$userHash'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw ServerException(
          'Failed to get user status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> startTrial(String userHash) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/user/start-trial'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'user_hash': userHash}),
          )
          .timeout(Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw ServerException(errorBody['error'] ?? 'Failed to start trial');
      }
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> validatePurchase({
    required String userHash,
    required String purchaseToken,
    required String platform,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/user/validate-purchase'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'user_hash': userHash,
              'purchase_token': purchaseToken,
              'platform': platform,
            }),
          )
          .timeout(Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw ServerException(
          errorBody['error'] ?? 'Failed to validate purchase',
        );
      }
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> redeemPromoCode({
    required String userHash,
    required String promoCode,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/promo/redeem'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'user_hash': userHash, 'promo_code': promoCode}),
          )
          .timeout(Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw ServerException(
          errorBody['error'] ?? 'Failed to redeem promo code',
        );
      }
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}
