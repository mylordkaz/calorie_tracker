import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/utils/localization_helper.dart';

class TargetDialog extends StatefulWidget {
  final double? currentTarget;

  const TargetDialog({Key? key, this.currentTarget}) : super(key: key);

  @override
  _TargetDialogState createState() => _TargetDialogState();

  static Future<double?> show(BuildContext context, {double? currentTarget}) {
    return showDialog<double>(
      context: context,
      builder: (context) => TargetDialog(currentTarget: currentTarget),
    );
  }
}

class _TargetDialogState extends State<TargetDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentTarget != null
          ? widget.currentTarget!.toInt().toString()
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        l10n.setDailyTarget,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: l10n.dailyCalorieTarget,
              suffixText: l10n.calories.toLowerCase(),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _saveTarget,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Text(l10n.save),
        ),
      ],
    );
  }

  void _saveTarget() {
    final target = double.tryParse(_controller.text);
    if (target != null && target > 0) {
      Navigator.pop(context, target);
    }
  }
}
