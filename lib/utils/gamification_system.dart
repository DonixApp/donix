import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamificationSystem extends ChangeNotifier {
  static const String _pointsKey = 'user_points';
  static const String _badgesKey = 'user_badges';

  int _points = 0;
  List<String> _badges = [];

  int get points => _points;
  List<String> get badges => _badges;

  GamificationSystem() {
    _loadData();
  }

  // Load points and badges from SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _points = prefs.getInt(_pointsKey) ?? 0;
    _badges = prefs.getStringList(_badgesKey) ?? [];
    notifyListeners(); // Notify listeners after loading data
  }

  // Add points and save to SharedPreferences
  Future<void> addPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    _points += points;
    await prefs.setInt(_pointsKey, _points);
    notifyListeners(); // Notify listeners after updating points
    await checkAndAwardBadges(); // Check for new badges
  }

  // Reset points and save to SharedPreferences
  Future<void> resetPoints() async {
    final prefs = await SharedPreferences.getInstance();
    _points = 0;
    await prefs.setInt(_pointsKey, _points);
    notifyListeners(); // Notify listeners after resetting points
  }

  // Add a badge and save to SharedPreferences
  Future<void> addBadge(String badge) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_badges.contains(badge)) {
      _badges.add(badge);
      await prefs.setStringList(_badgesKey, _badges);
      notifyListeners(); // Notify listeners after adding a badge
    }
  }

  // Check and award badges based on points
  Future<void> checkAndAwardBadges() async {
    if (_points >= 100 && !_badges.contains('Bronze Donor')) {
      await addBadge('Bronze Donor');
    }
    if (_points >= 500 && !_badges.contains('Silver Donor')) {
      await addBadge('Silver Donor');
    }
    if (_points >= 1000 && !_badges.contains('Gold Donor')) {
      await addBadge('Gold Donor');
    }
  }

  // Award points for specific actions
  Future<void> awardPointsForDonation() async {
    await addPoints(100);
  }

  Future<void> awardPointsForReferral() async {
    await addPoints(50);
  }

  Future<void> awardPointsForEducation() async {
    await addPoints(10);
  }
}