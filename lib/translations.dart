// ignore_for_file: null_check_always_fails

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show  rootBundle;

// Classe personnalisée pour la gestion de la traduction

class AppTranslations {
  //  Constructor
  AppTranslations(Locale? locale) {
    this.locale = locale!;
   // _localizedValues = null!;
  }

  Locale? locale;
  static Map<dynamic, dynamic> ?_localizedValues;

  static AppTranslations? of(BuildContext context){
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  String text(String key) {
    return _localizedValues![key] ?? '** $key not found';
  }
  static Future<AppTranslations> load(Locale locale) async {
    AppTranslations translations =  AppTranslations(locale);
    String jsonContent = await rootBundle.loadString("locale/i18n_${locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);
    return translations;
  }

  get currentLanguage => locale?.languageCode;
}

class TranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en','fr'].contains(locale.languageCode);

  @override
  Future<AppTranslations> load(Locale locale) => AppTranslations.load(locale);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}
