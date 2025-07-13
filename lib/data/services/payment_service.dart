import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nibble/data/services/server_api_service.dart';
import 'package:nibble/data/services/user_status_service.dart';

class PaymentService {
  static const String _basicProductId = 'nibble_basic_purchase';
  static final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;

  // initialize service
  static Future<void> init() async {
    final Stream<List<PurchaseDetails>> purchaseUpdatedStream =
        _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdatedStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) => print('Purchase stream error: $error'),
    );
  }

  // check if store available
  static Future<bool> isStoreAvailable() async {
    return await _inAppPurchase.isAvailable();
  }

  // get product details & prices
  static Future<ProductDetails?> getBasicProductDetails() async {
    const Set<String> productIds = {_basicProductId};
    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      print('Products not found: ${response.notFoundIDs}');
      return null;
    }
  }

  // initiate purchase
  static Future<bool> purchaseBasic() async {
    try {
      final productDetails = await getBasicProductDetails();
      if (productDetails == null) {
        throw Exception('Product not found');
      }

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      return await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
    } catch (e) {
      print('Purchase initiation failed: $e');
      return false;
    }
  }

  // restore purchase
  static Future<void> restorePurchase() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      print('Restore purchase failed: $e');
      rethrow;
    }
  }

  // handle purchase updates
  static void _onPurchaseUpdate(List<PurchaseDetails> PurchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in PurchaseDetailsList) {
      _handlePurchase(purchaseDetails);
    }
  }

  // Process individual purchase
  static Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    print('Purchase status: ${purchaseDetails.status}');
    print('Product ID: ${purchaseDetails.productID}');

    switch (purchaseDetails.status) {
      case PurchaseStatus.pending:
        print('Purchase pending...');
        break;

      case PurchaseStatus.purchased:
        print('✅ Purchase successful!');
        await _processPurchase(purchaseDetails);
        break;

      case PurchaseStatus.error:
        print('❌ Purchase failed: ${purchaseDetails.error}');
        break;

      case PurchaseStatus.canceled:
        print('Purchase canceled by user');
        break;

      case PurchaseStatus.restored:
        print('✅ Purchase restored!');
        await _processPurchase(purchaseDetails);
        break;
    }

    // complete purchase
    if (purchaseDetails.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetails);
    }
  }

  // Process successful purchase
  static Future<void> _processPurchase(PurchaseDetails purchaseDetails) async {
    try {
      // Validate with server
      await _validatePurchaseWithServer(purchaseDetails);

      // Update local status
      await UserStatusService.markAsPurchasedWithServer(
        purchaseToken: purchaseDetails.verificationData.serverVerificationData,
        purchaseDate: DateTime.fromMillisecondsSinceEpoch(
          int.parse(purchaseDetails.transactionDate ?? '0'),
        ),
      );

      print('✅ Purchase processed successfully');
    } catch (e) {
      print('❌ Purchase processing failed: $e');
    }
  }

  // Validate purchase with server
  static Future<void> _validatePurchaseWithServer(
    PurchaseDetails details,
  ) async {
    await ServerApiService.validatePurchase(
      userHash: (await UserStatusService.getUserStatus()).userHash,
      purchaseToken: details.verificationData.serverVerificationData,
      platform: Platform.isIOS ? 'apple' : 'google',
    );
  }

  // Cleanup
  static void dispose() {
    _subscription?.cancel();
  }
}
