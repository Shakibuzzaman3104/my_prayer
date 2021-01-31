import 'dart:ui';

import 'package:flutter/material.dart';

import 'Localization.dart';

class LocalizationDelegates extends LocalizationsDelegate<Localization> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const LocalizationDelegates();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'bn'].contains(locale.languageCode);
  }

  @override
  Future<Localization> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    Localization localizations = new Localization(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationDelegates old) => false;
}
