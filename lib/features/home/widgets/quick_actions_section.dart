import 'package:flutter/material.dart';
import '../../../core/utils/localization_helper.dart';
import 'todays_log_card.dart';
import 'copy_yesterday_button.dart';

class QuickActionsSection extends StatelessWidget {
  final List<Map<String, dynamic>> todayEntries;
  final VoidCallback onCopyYesterday;
  final VoidCallback? onViewAllEntries;

  const QuickActionsSection({
    Key? key,
    required this.todayEntries,
    required this.onCopyYesterday,
    this.onViewAllEntries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickActions,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12),
        TodaysLogCard(entries: todayEntries, onViewAll: onViewAllEntries),
        SizedBox(height: 8),
        CopyYesterdayButton(onPressed: onCopyYesterday),
      ],
    );
  }
}
