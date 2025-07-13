import 'package:flutter/material.dart';
import 'package:nibble/core/utils/localization_helper.dart';
import 'package:nibble/data/services/payment_service.dart';
import 'package:nibble/features/payment/widgets/promo_confirmation_dialog.dart';
import '../../../data/services/access_control_service.dart';
import '../../../data/services/user_status_service.dart';
import '../../../core/utils/trial_status_helper.dart';
import '../widgets/trial_confirmation_dialog.dart';

class PurchaseScreen extends StatefulWidget {
  final VoidCallback? onPurchaseComplete;
  final TrialStatusData? statusData;

  const PurchaseScreen({Key? key, this.onPurchaseComplete, this.statusData})
    : super(key: key);

  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  bool _isLoading = false;
  TrialStatusData? _statusData;
  final _promoCodeController = TextEditingController();
  bool _showPromoCode = false;

  @override
  void initState() {
    super.initState();
    _statusData = widget.statusData;
    if (_statusData == null) {
      _loadStatusData();
    }
  }

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadStatusData() async {
    final data = await AccessControlService.getTrialStatusData();
    setState(() {
      _statusData = data;
    });
  }

  Future<void> _startTrial() async {
    final l10n = L10n.of(context);

    setState(() {
      _isLoading = true;
    });

    try {
      final started = await UserStatusService.startTrialWithServer();
      if (started) {
        setState(() {
          _isLoading = false;
        });

        // Show trial confirmation dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TrialConfirmationDialog(
            onContinue: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              widget.onPurchaseComplete?.call();
            },
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        _showMessage(l10n.accessControlTrialAlreadyUsed);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showMessage(l10n.accessControlErrorStartingTrial(e.toString()));
    }
  }

  Future<void> _purchaseBasic() async {
    final l10n = L10n.of(context);

    setState(() {
      _isLoading = true;
    });

    try {
      // Check store availability
      if (!await PaymentService.isStoreAvailable()) {
        throw Exception('App Store not available');
      }

      // Initiate purchase
      final success = await PaymentService.purchaseBasic();
      if (!success) {
        throw Exception('Failed to initiate purchase');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showMessage(l10n.accessControlPurchaseFailed(e.toString()));
    }
  }

  Future<void> _redeemPromoCode() async {
    final l10n = L10n.of(context);
    if (_promoCodeController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final promoCode = _promoCodeController.text.trim();

      await UserStatusService.redeemPromoCodeWithServer(promoCode);

      setState(() {
        _isLoading = false;
      });

      // Show promo confirmation dialog
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PromoConfirmationDialog(
          promoCode: promoCode,
          onContinue: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Pop the PurchaseScreen
            widget.onPurchaseComplete?.call();
          },
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showMessage(l10n.invalidPromoCode);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    String statusMessage = '';
    if (_statusData != null) {
      statusMessage = TrialStatusHelper.getStatusMessage(context, _statusData!);
    }

    final basicPrice = '';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 40),

                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/icon/app_icon.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback if logo not found
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[400]!,
                                      Colors.blue[600]!,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.restaurant_menu,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 32),

                      Text(
                        l10n.appName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                          letterSpacing: -0.5,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        l10n.appTagline,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 40),

                      // Status message
                      if (statusMessage.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue[600],
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  statusMessage,
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Trial button (only show for new users)
                      FutureBuilder<bool>(
                        future: UserStatusService.isNewUser(),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _startTrial,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[500],
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: _isLoading
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            l10n.purchaseStartFreeTrial,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),

                      // Purchase button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.25),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _purchaseBasic,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      l10n.purchaseUnlockFullAccess,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (basicPrice.isNotEmpty)
                                      Text(
                                        l10n.purchaseOneTimePayment(basicPrice),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                  ],
                                ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Promo code section
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showPromoCode = !_showPromoCode;
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          l10n.havePromoCode,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      if (_showPromoCode) ...[
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: _promoCodeController,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                                decoration: InputDecoration(
                                  hintText: l10n.enterPromoCode,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.blue[600]!,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                textCapitalization:
                                    TextCapitalization.characters,
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _redeemPromoCode,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[800],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    l10n.redeemCode,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      SizedBox(height: 32),

                      // Benefits
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[100]!),
                        ),
                        child: Column(
                          children: [
                            _buildBenefit(l10n.purchaseBenefitNoSubscriptions),
                            _buildBenefit(l10n.purchaseBenefitDataPrivacy),
                            _buildBenefit(l10n.purchaseBenefitNoAds),
                            _buildBenefit(l10n.purchaseBenefitUnlimited),
                          ],
                        ),
                      ),

                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Terms and privacy
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.purchaseTermsAndPrivacy,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.check, color: Colors.green[600], size: 16),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
