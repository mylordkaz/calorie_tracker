import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/export_controller.dart';
import '../../../core/utils/localization_helper.dart';

class LibraryExportButton extends StatelessWidget {
  const LibraryExportButton({super.key});

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
                content: Text('${l10n.exportFailed}: ${controller.exportError}'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 4),
              ),
            );
            controller.clearMessages();
          }
        });

        return PopupMenuButton<String>(
          icon: controller.isBusy
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : Icon(Icons.settings),
          enabled: !controller.isBusy,
          onSelected: (value) =>
              _handleExportAction(context, controller, value),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'export_foods',
              child: _ExportMenuItem(
                icon: Icons.upload,
                label: l10n.exportFoods,
                isLoading: controller.isExportingFoods,
              ),
            ),
            PopupMenuItem(
              value: 'export_meals',
              child: _ExportMenuItem(
                icon: Icons.upload,
                label: l10n.exportMeals,
                isLoading: controller.isExportingMeals,
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              value: 'import_foods',
              child: _ExportMenuItem(
                icon: Icons.download,
                label: l10n.importFoods,
                isLoading: controller.isImportingFoods,
              ),
            ),
            PopupMenuItem(
              value: 'import_meals',
              child: _ExportMenuItem(
                icon: Icons.download,
                label: l10n.importMeals,
                isLoading: controller.isImportingMeals,
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleExportAction(
    BuildContext context,
    ExportController controller,
    String action,
  ) {
    final l10n = L10n.of(context);
    
    switch (action) {
      case 'export_foods':
        _showConfirmDialog(
          context,
          l10n.exportFoodLibrary,
          l10n.exportFoodLibraryDescription,
          Icons.upload,
          () => controller.exportFoodLibrary(l10n.exportFoodLibrarySuccess),
        );
        break;
      case 'export_meals':
        _showConfirmDialog(
          context,
          l10n.exportMealLibrary,
          l10n.exportMealLibraryDescription,
          Icons.upload,
          () => controller.exportMealLibrary(l10n.exportMealLibrarySuccess),
        );
        break;
      case 'import_foods':
        _showConfirmDialog(
          context,
          l10n.importFoodLibrary,
          l10n.importFoodLibraryDescription,
          Icons.download,
          () => controller.importFoodLibrary('Import completed'),
        );
        break;
      case 'import_meals':
        _showConfirmDialog(
          context,
          l10n.importMealLibrary,
          l10n.importMealLibraryDescription,
          Icons.download,
          () => controller.importMealLibrary('Import completed'),
        );
        break;
    }
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    VoidCallback onConfirm,
  ) {
    final l10n = L10n.of(context);
    final isImport = title.toLowerCase().contains('import');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, size: 24),
            SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.of(context).cancel),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            icon: Icon(isImport ? Icons.download : Icons.upload, size: 18),
            label: Text(isImport ? l10n.import : l10n.export),
          ),
        ],
      ),
    );
  }
}

class _ExportMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLoading;

  const _ExportMenuItem({
    required this.icon,
    required this.label,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        SizedBox(width: 12),
        Expanded(child: Text(label)),
        if (isLoading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }
}
