import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/export_controller.dart';
import '../../../core/utils/localization_helper.dart';

class CalendarExportButton extends StatefulWidget {
  const CalendarExportButton({super.key});

  @override
  State<CalendarExportButton> createState() => _CalendarExportButtonState();
}

class _CalendarExportButtonState extends State<CalendarExportButton> {
  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Consumer<ExportController>(
      builder: (context, controller, child) {
        // Show SnackBar notifications for export results
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.lastSuccessMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(controller.lastSuccessMessage!),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            controller.clearMessages();
          } else if (controller.exportError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${l10n.exportFailed}: ${controller.exportError}',
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 4),
              ),
            );
            controller.clearMessages();
          }
        });

        return IconButton(
          icon: controller.isExportingCalendar
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : Icon(Icons.settings),
          onPressed: controller.isExportingCalendar
              ? null
              : () => _showExportDialog(context, controller),
        );
      },
    );
  }

  void _showExportDialog(BuildContext context, ExportController controller) {
    final l10n = L10n.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.download, size: 24),
            SizedBox(width: 8),
            Expanded(child: Text(l10n.exportCalendarData)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.chooseTimePeriodToExport,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            _ExportButton(
              label: l10n.chooseDateRange,
              onPressed: () {
                Navigator.pop(context);
                _showDateRangePicker(context, controller);
              },
            ),
            SizedBox(height: 8),
            _ExportButton(
              label: l10n.allTime,
              onPressed: () {
                Navigator.pop(context);
                controller.exportCalendarData(
                  successMessage: l10n.exportCalendarDataSuccess,
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showDateRangePicker(
    BuildContext context,
    ExportController controller,
  ) async {
    final l10n = L10n.of(context);

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(Duration(days: 30)),
        end: DateTime.now(),
      ),
    );

    if (picked != null && mounted) {
      controller.exportCalendarData(
        startDate: picked.start,
        endDate: picked.end,
        successMessage: l10n.exportCalendarDataSuccess,
      );
    }
  }
}

class _ExportButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ExportButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.file_download, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(alignment: Alignment.centerLeft),
      ),
    );
  }
}
