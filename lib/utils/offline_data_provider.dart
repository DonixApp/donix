import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OfflineDataProvider with ChangeNotifier {
  Map<String, dynamic> _offlineData = {};

  Map<String, dynamic> get offlineData => _offlineData;

  Future<void> loadOfflineData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('offline_data');
    if (jsonString != null) {
      _offlineData = json.decode(jsonString);
      notifyListeners();
    }
  }

  Future<void> saveOfflineData(String key, dynamic value) async {
    _offlineData[key] = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('offline_data', json.encode(_offlineData));
    notifyListeners();
  }
}

