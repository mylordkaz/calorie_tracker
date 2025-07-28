import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/export_controller.dart';
import '../../../core/utils/localization_helper.dart';

class ExportStatusBanner extends StatefulWidget {
  const ExportStatusBanner({super.key});

  @override
  State<ExportStatusBanner> createState() => _ExportStatusBannerState();
}

class _ExportStatusBannerState extends State<ExportStatusBanner> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExportController>(
      builder: (context, controller, child) {
        if (controller.lastSuccessMessage != null) {
          Future.delayed(Duration(seconds: 2), () {
            if (mounted && controller.lastSuccessMessage != null) {
              controller.clearMessages();
            }
          });
        }

        // Show error banner
        if (controller.exportError != null) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Theme.of(context).colorScheme.errorContainer,
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        L10n.of(context).exportFailed,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        controller.exportError!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  onPressed: controller.clearMessages,
                ),
              ],
            ),
          );
        }

        // Show success banner
        if (controller.lastSuccessMessage != null) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.green.shade100,
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green.shade800),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.lastSuccessMessage!,
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.green.shade800),
                  onPressed: controller.clearMessages,
                ),
              ],
            ),
          );
        }

        // No status to show
        return SizedBox.shrink();
      },
    );
  }
}
