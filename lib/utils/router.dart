import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/blood_request_form.dart';
import '../screens/chatbot_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/find_donors_screen.dart';
import '../screens/history_screen.dart';
import '../screens/profile/delete_account_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/profile_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../screens/chatbot_screen.dart';
// Import other screens


final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/profile/delete-account',
      builder: (context, state) => const DeleteAccountScreen(),
    ),
    GoRoute(
      path: '/find-donors',
      builder: (context, state) => const FindDonorsScreen(),
    ),
    GoRoute(
      path: '/blood-request',
      builder: (context, state) => const BloodRequestForm(),
    ),

    GoRoute(
      path: '/history-screen',
      builder: (context, state) =>  HistoryScreen(),
    ),
    GoRoute(
      path: '/chatbot',
      builder: (context, state) => ChatbotScreen(),
    ),

  ],
);
