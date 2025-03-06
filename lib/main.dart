import 'package:donix/screens/auth/forgot_password_screen.dart';
import 'package:donix/screens/auth/login_screen.dart';
import 'package:donix/screens/auth/register_screen.dart';
import 'package:donix/screens/auth/welcome_screen.dart';
import 'package:donix/utils/auth_notifier.dart';
import 'package:donix/utils/language_notifier.dart';
import 'package:donix/utils/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:donix/screens/dashboard_screen.dart';
import 'package:donix/screens/profile/profile_screen.dart';
import 'package:donix/screens/profile/edit_profile_screen.dart';
import 'package:donix/screens/profile/delete_account_screen.dart';
import 'package:donix/utils/navigation_service.dart';
import 'package:donix/screens/donations_screen.dart';
import 'package:donix/screens/requests_screen.dart';
import 'package:donix/screens/find_donors_screen.dart';
import 'package:donix/screens/education_screen.dart';
import 'package:donix/screens/community_screen.dart';
import 'package:donix/screens/chatbot_screen.dart';
import 'package:donix/screens/blood_request_form.dart';
import 'package:go_router/go_router.dart';

// ✅ Riverpod State Notifiers
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

// ✅ GoRouter Configuration
final _router = GoRouter(
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
      path: '/home',
      builder: (context, state) => const HomeScreen(),
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
      path: '/donate',
      builder: (context, state) => DonationsScreen(),
    ),
    GoRoute(
      path: '/requests',
      builder: (context, state) => const RequestsScreen(),
    ),
    GoRoute(
      path: '/find',
      builder: (context, state) => const FindDonorsScreen(),
    ),
    GoRoute(
      path: '/blood-request',
      builder: (context, state) => const BloodRequestForm(),
    ),
    GoRoute(
      path: '/learn',
      builder: (context, state) => EducationScreen(),
    ),
    GoRoute(
      path: '/community',
      builder: (context, state) => CommunityScreen(),
    ),
    GoRoute(
      path: '/chatbot',
      builder: (context, state) => ChatbotScreen(),
    ),
  ],
);

void main() {
  runApp(
    const ProviderScope(
      child: DonixApp(),
    ),
  );
}

class DonixApp extends ConsumerWidget {
  const DonixApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final currentLocale = ref.watch(languageProvider);

    return MaterialApp.router(
      routerConfig: _router,
      title: 'Donix',
      theme: ThemeData(
        primaryColor: const Color(0xFFEF4444),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEF4444),
          primary: const Color(0xFFEF4444),
          secondary: const Color(0xFF7C3AED),
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        scaffoldBackgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFF9FAFB),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ha', ''),
        Locale('yo', ''),
        Locale('ig', ''),
      ],
      locale: currentLocale,
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const DashboardScreen(),
    DonationsScreen(),
    const RequestsScreen(),
    const FindDonorsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Donate',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Find',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

