import 'package:flutter/material.dart';
import '../../features/payment/screens/purchase_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../data/services/access_control_service.dart';
import '../../data/services/user_status_service.dart';
import '../../core/utils/trial_status_helper.dart';
import '../../core/utils/localization_helper.dart';

class AccessControlWrapper extends StatefulWidget {
  final Widget child;

  const AccessControlWrapper({required this.child});

  @override
  _AccessControlWrapperState createState() => _AccessControlWrapperState();
}

class _AccessControlWrapperState extends State<AccessControlWrapper> {
  bool _isLoading = true;
  bool _hasAccess = false;
  bool _isNewUser = false;
  bool _showWarning = false;
  TrialStatusData? _statusData;

  @override
  void initState() {
    super.initState();
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await UserStatusService.syncWithServer();

      // Check if user is new
      final isNewUser = await UserStatusService.isNewUser();

      // Get access status
      final hasAccess = await AccessControlService.canAccessApp();
      final statusData = await AccessControlService.getTrialStatusData();
      final showWarning = await AccessControlService.shouldShowTrialWarning();

      if (mounted) {
        setState(() {
          _isNewUser = isNewUser;
          _hasAccess = hasAccess;
          _statusData = statusData;
          _showWarning = showWarning;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasAccess = false;
          _isNewUser = true;
          _isLoading = false;
        });
      }
    }
  }

  void _refreshAccess() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(milliseconds: 100));
    _checkAccess();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.blue),
              SizedBox(height: 16),
              Text(l10n.accessControlCheckingAccess),
            ],
          ),
        ),
      );
    }

    // Show welcome screen for new users
    if (_isNewUser) {
      return WelcomeScreen(onComplete: _refreshAccess);
    }

    // Show purchase screen if no access
    if (!_hasAccess) {
      return PurchaseScreen(
        onPurchaseComplete: _refreshAccess,
        statusData: _statusData,
      );
    }

    // Show trial warning if needed
    if (_showWarning && _statusData != null) {
      final statusMessage = TrialStatusHelper.getStatusMessage(
        context,
        _statusData!,
      );

      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.orange.shade100,
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange.shade700, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    statusMessage,
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PurchaseScreen(
                          onPurchaseComplete: _refreshAccess,
                          statusData: _statusData,
                        ),
                      ),
                    );
                  },
                  child: Text(l10n.accessControlUpgrade),
                ),
              ],
            ),
          ),
          Expanded(child: widget.child),
        ],
      );
    }

    // Show main app
    return widget.child;
  }
}
