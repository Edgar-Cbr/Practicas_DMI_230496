import 'package:flutter/material.dart';

/// Un idioma disponible en la app.
///
/// - [apiCode]: código que se envía a The Movie DB (`language=`).
/// - [locale]: idioma que usa Flutter para textos, fechas y dirección (RTL).
class AppLanguage {
  final String country;      // MX, US, DE, FR, JP
  final String nativeName;   // Cómo se llama el idioma en su propio idioma
  final Locale locale;

  const AppLanguage({
    required this.country,
    required this.nativeName,
    required this.locale,
  });

  String get code => locale.languageCode;
  String get apiCode => '${locale.languageCode}-${locale.countryCode}';

  /// Texto que se muestra en el menú, p. ej. "MX (Español)".
  String get label => '$country ($nativeName)';
}

class AppLanguages {

  static const mexico = AppLanguage(
    country: 'MX',
    nativeName: 'Español',
    locale: Locale('es', 'MX'),
  );

  static const unitedStates = AppLanguage(
    country: 'US',
    nativeName: 'English',
    locale: Locale('en', 'US'),
  );

  static const germany = AppLanguage(
    country: 'DE',
    nativeName: 'Deutsch',
    locale: Locale('de', 'DE'),
  );

  static const france = AppLanguage(
    country: 'FR',
    nativeName: 'Français',
    locale: Locale('fr', 'FR'),
  );

  static const japan = AppLanguage(
    country: 'JP',
    nativeName: '日本語',
    locale: Locale('ja', 'JP'),
  );

  /// Orden en el que aparecen en el menú lateral.
  static const all = <AppLanguage>[mexico, unitedStates, germany, france, japan];

  static const defaultLanguage = mexico;
}
