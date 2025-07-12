import 'package:flutter/material.dart';
import 'package:nibble/core/utils/localization_helper.dart';
import '../../../data/services/access_control_service.dart';
import '../../../data/services/user_status_service.dart';
import '../../../core/utils/trial_status_helper.dart';

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

  @override
  void initState() {
    super.initState();
    _statusData = widget.statusData;
    if (_statusData == null) {
      _loadStatusData();
    }
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
      final started = await UserStatusService.startTrial();
      if (started) {
        widget.onPurchaseComplete?.call();
      } else {
        _showMessage(l10n.accessControlTrialAlreadyUsed);
      }
    } catch (e) {
      _showMessage(l10n.accessControlErrorStartingTrial(e.toString()));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _purchaseBasic() async {
    final l10n = L10n.of(context);

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement actual purchase logic with platform stores
      await Future.delayed(Duration(seconds: 2));

      await UserStatusService.markAsPurchased(
        purchaseToken: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      widget.onPurchaseComplete?.call();
    } catch (e) {
      _showMessage(l10n.accessControlPurchaseFailed(e.toString()));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Spacer(),

              // App logo/icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.restaurant_menu,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              SizedBox(height: 24),

              Text(
                l10n.appName,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8),

              Text(
                l10n.appTagline,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),

              SizedBox(height: 32),

              // Status message
              if (statusMessage.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          statusMessage,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 32),

              // Trial button (only show for new users)
              FutureBuilder<bool>(
                future: UserStatusService.isNewUser(),
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _startTrial,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    l10n.purchaseStartFreeTrial,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),

              // Purchase button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _purchaseBasic,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.purchaseUnlockFullAccess,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              l10n.purchaseOneTimePayment(basicPrice),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              SizedBox(height: 24),

              // Benefits
              Column(
                children: [
                  _buildBenefit(l10n.purchaseBenefitNoSubscriptions),
                  _buildBenefit(l10n.purchaseBenefitDataPrivacy),
                  _buildBenefit(l10n.purchaseBenefitNoAds),
                  _buildBenefit(l10n.purchaseBenefitUnlimited),
                ],
              ),

              Spacer(),

              // Terms and privacy
              Text(
                l10n.purchaseTermsAndPrivacy,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
