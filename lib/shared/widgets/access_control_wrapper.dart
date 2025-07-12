import 'package:flutter/material.dart';
import 'package:nibble/core/utils/localization_helper.dart';
import '../../data/services/access_control_service.dart';
import '../../features/payment/screens/purchase_screen.dart';
import '../../core/utils/trial_status_helper.dart';

class AccessControlWrapper extends StatefulWidget {
  final Widget child;
  final bool showTrialWarning;

  const AccessControlWrapper({
    Key? key,
    required this.child,
    this.showTrialWarning = true,
  }) : super(key: key);

  @override
  _AccessControlWrapperState createState() => _AccessControlWrapperState();
}

class _AccessControlWrapperState extends State<AccessControlWrapper>
    with WidgetsBindingObserver {
  bool _hasAccess = false;
  bool _isLoading = true;
  bool _showWarning = false;
  TrialStatusData? _statusData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAccess();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAccess();
    }
  }

  Future<void> _checkAccess() async {
    try {
      await AccessControlService.handleFirstLaunch();

      final hasAccess = await AccessControlService.canAccessApp();
      final shouldWarn =
          widget.showTrialWarning &&
          await AccessControlService.shouldShowTrialWarning();
      final statusData = await AccessControlService.getTrialStatusData();

      if (mounted) {
        setState(() {
          _hasAccess = hasAccess;
          _showWarning = shouldWarn;
          _statusData = statusData;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error checking access: $e');
      if (mounted) {
        setState(() {
          _hasAccess = false;
          _isLoading = false;
        });
      }
    }
  }

  void _refreshAccess() {
    setState(() {
      _isLoading = true;
    });
    _checkAccess();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(l10n.accessControlCheckingAccess),
            ],
          ),
        ),
      );
    }

    if (!_hasAccess) {
      return PurchaseScreen(
        onPurchaseComplete: _refreshAccess,
        statusData: _statusData,
      );
    }

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

    return widget.child;
  }
}
