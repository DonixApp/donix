import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = Locale('en', '');

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale locale) {
    if (!['en', 'ha', 'yo', 'ig'].contains(locale.languageCode)) return;

    _currentLocale = locale;
    notifyListeners();
  }

  String getText(String key) {
    // Implement a proper localization system here
    // This is just a simple example
    switch (_currentLocale.languageCode) {
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

