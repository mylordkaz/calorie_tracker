import 'package:flutter/material.dart';
import '../../../core/utils/localization_helper.dart';

class CopyYesterdayButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CopyYesterdayButton({Key? key, required this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.copy, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.copyFromYesterday,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        l10n.addAllYesterdayEntries,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
