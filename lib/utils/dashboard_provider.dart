import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserData>((ref) {
  return UserDataNotifier();
});

class UserData {
  final String name;
  final String bloodType;
  final String profileImage;

  UserData({
    required this.name,
    required this.bloodType,
    required this.profileImage,
  });
}

class UserDataNotifier extends StateNotifier<UserData> {
  UserDataNotifier()
      : super(UserData(
    name: 'Sadisu',
    bloodType: 'O+',
    profileImage: 'assets/images/placeholder_avatar.png', // Changed from https://example.com/profile.jpg
  ));
}

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false);

  void toggleTheme() {
    state = !state;
  }
}

