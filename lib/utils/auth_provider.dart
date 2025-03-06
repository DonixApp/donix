import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  String _userId = "guest_user";
  String _userName = "Guest User";
  String _bloodType = "Unknown";
  bool _isAuthenticated = false;

  String get userId => _userId;
  String get userName => _userName;
  String get bloodType => _bloodType;
  bool get isAuthenticated => _isAuthenticated;

  // Simulated user authentication (without login/registration)
  void authenticateGuestUser() {
    _isAuthenticated = true;
    notifyListeners();
  }

  // Update user details (for future profile editing)
  void updateUserDetails({String? name, String? bloodType}) {
    if (name != null) _userName = name;
    if (bloodType != null) _bloodType = bloodType;
    notifyListeners();
  }

  // Logout functionality (resets to guest mode)
  void logout() {
    _isAuthenticated = false;
    _userId = "guest_user";
    _userName = "Guest User";
    _bloodType = "Unknown";
    notifyListeners();
  }
}
