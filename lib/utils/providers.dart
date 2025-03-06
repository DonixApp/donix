import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/theme_notifier.dart';
import '../utils/auth_notifier.dart';

// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

