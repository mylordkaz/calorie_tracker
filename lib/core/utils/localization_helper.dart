import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class L10n {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}
