import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('en', ''));

  void setLocale(Locale locale) {
    if (['en', 'ha', 'yo', 'ig'].contains(locale.languageCode)) {
      state = locale;
    }
  }

  String getText(String key) {
    switch (state.languageCode) {
      case 'ha':
        return _haTexts[key] ?? key;
      case 'yo':
        return _yoTexts[key] ?? key;
      case 'ig':
        return _igTexts[key] ?? key;
      default:
        return key;
    }
  }

  // Sample translations
  final Map<String, String> _haTexts = {
    'Home': 'Gida',
    'Donate': 'Bayar da gudummawa',
    // Add more translations
  };

  final Map<String, String> _yoTexts = {
    'Home': 'Ile',
    'Donate': 'Ṣetọrẹ',
    // Add more translations
  };

  final Map<String, String> _igTexts = {
    'Home': 'Ụlọ',
    'Donate': 'Nye onyinye',
    // Add more translations
  };
}

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

