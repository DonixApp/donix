import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../utils/theme_notifier.dart';
import '../utils/language_notifier.dart';
import 'package:donix/screens/profile/delete_account_screen.dart';

import 'account_section.dart';

final notificationsEnabledProvider = StateProvider<bool>((ref) => true);
final locationEnabledProvider = StateProvider<bool>((ref) => false);
final bloodReminderEnabledProvider = StateProvider<bool>((ref) => true);

// Donation goals providers
final donationGoalProvider = StateProvider<int>((ref) => 3); // Default goal: 3 donations
final donationGoalYearProvider = StateProvider<int>((ref) => DateTime.now().year + 1); // Default: next year
final donationGoalEnabledProvider = StateProvider<bool>((ref) => false);
final donationPointsProvider = StateProvider<int>((ref) => 0); // Current points

class SettingsSection extends ConsumerWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final locationEnabled = ref.watch(locationEnabledProvider);
    final isDarkMode = ref.watch(themeProvider);
    final bloodReminderEnabled = ref.watch(bloodReminderEnabledProvider);
    final currentLocale = ref.watch(languageProvider);
    final donationGoalEnabled = ref.watch(donationGoalEnabledProvider);

    // Get language name based on locale
    String getLanguageName() {
      if (currentLocale.languageCode == 'en') return 'English';
      if (currentLocale.languageCode == 'ha') return 'Hausa';
      if (currentLocale.languageCode == 'yo') return 'Yoruba';
      if (currentLocale.languageCode == 'ig') return 'Igbo';
      return 'English';
    }

    return Container(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 16),
            child: Text(
              'App Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),

          // Theme Mode
          SettingsItem(
            icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
            title: 'Dark Mode',
            subtitle: isDarkMode ? 'Currently using dark theme' : 'Currently using light theme',
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                ref.read(themeProvider.notifier).setTheme(value);
              },
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
            isDarkMode: isDarkMode,
          ),
          const Divider(),

          // Language
          SettingsItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'Currently set to ${getLanguageName()}',
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: () {
              _showLanguageSelector(context, ref);
            },
            isDarkMode: isDarkMode,
          ),
          const Divider(),

          // Notifications
          SettingsItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: notificationsEnabled ? 'Enabled' : 'Disabled',
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                ref.read(notificationsEnabledProvider.notifier).state = value;
              },
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
            isDarkMode: isDarkMode,
          ),
          const Divider(),

          // Location Sharing
          SettingsItem(
            icon: Icons.location_on_outlined,
            title: 'Share Location',
            subtitle: 'Allow nearby donors to discover you',
            trailing: Switch(
              value: locationEnabled,
              onChanged: (value) {
                ref.read(locationEnabledProvider.notifier).state = value;
              },
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
            isDarkMode: isDarkMode,
          ),
          const Divider(),

          // Donation Reminders
          SettingsItem(
            icon: Icons.calendar_today_outlined,
            title: 'Donation Reminders',
            subtitle: 'Get notified when you\'re eligible to donate again',
            trailing: Switch(
              value: bloodReminderEnabled,
              onChanged: (value) {
                ref.read(bloodReminderEnabledProvider.notifier).state = value;
              },
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
            isDarkMode: isDarkMode,
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.only(left: 8, top: 16, bottom: 16),
            child: Text(
              'Donation Goals & Rewards',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),

          // Donation Goals
          SettingsItem(
            icon: Icons.emoji_events,
            title: 'Set Donation Goals',
            subtitle: donationGoalEnabled
                ? 'Goal: ${ref.watch(donationGoalProvider)} donations in ${ref.watch(donationGoalYearProvider)}'
                : 'Set your yearly donation target',
            trailing: Switch(
              value: donationGoalEnabled,
              onChanged: (value) {
                ref.read(donationGoalEnabledProvider.notifier).state = value;
                if (value) {
                  _showDonationGoalSetter(context, ref);
                }
              },
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
            isDarkMode: isDarkMode,
          ),
          const Divider(),

          // Rewards Program
          SettingsItem(
            icon: Icons.card_giftcard,
            title: 'Rewards Program',
            subtitle: 'View your points and available rewards',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${ref.watch(donationPointsProvider)} pts',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              _showRewardsDialog(context, ref);
            },
            isDarkMode: isDarkMode,
          ),
          const Divider(),

          // Partner Stores
          SettingsItem(
            icon: Icons.store,
            title: 'Partner Stores',
            subtitle: 'View stores where you can redeem rewards',
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: () {
              // Navigate to Partner Stores screen
            },
            isDarkMode: isDarkMode,
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.only(left: 8, top: 16, bottom: 16),
            child: Text(
              'Account & Privacy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),

          // Account Settings
          SettingsItem(
            icon: Icons.person_outline,
            title: 'Account Settings',
            subtitle: 'Manage your profile and account details',
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: () {
              context.push('/profile/edit');
            },
            isDarkMode: isDarkMode,
          ),
          const Divider(),

          // Privacy & Security
          SettingsItem(
            icon: Icons.lock_outline,
            title: 'Privacy & Security',
            subtitle: 'Manage your data and security settings',
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: () {
              // Navigate to Privacy & Security screen
            },
            isDarkMode: isDarkMode,
          ),
          const Divider(),

          // Donation Centers
          SettingsItem(
            icon: Icons.local_hospital_outlined,
            title: 'Donation Centers',
            subtitle: 'Find and manage your preferred donation centers',
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: () {
              // Navigate to Donation Centers screen
            },
            isDarkMode: isDarkMode,
          ),
          const Divider(),

          // Referrals
          SettingsItem(
            icon: Icons.people_outline,
            title: 'Referrals',
            subtitle: 'Invite friends to join Donix',
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: () {
              // Navigate to Referrals screen
            },
            isDarkMode: isDarkMode,
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.only(left: 8, top: 16, bottom: 16),
            child: Text(
              'Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),

          // Help & Support
          SettingsItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help with using the app',
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: () {
              // Navigate to Help & Support screen
            },
            isDarkMode: isDarkMode,
          ),
          const Divider(),

          // About
          SettingsItem(
            icon: Icons.info_outline,
            title: 'About Donix',
            subtitle: 'Learn more about our mission and team',
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: () {
              // Navigate to About screen
            },
            isDarkMode: isDarkMode,
          ),
          const Divider(),
          // Delete Account
          AccountItem(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            textColor: Theme.of(context).colorScheme.error,
            iconColor: Theme.of(context).colorScheme.error,
            onTap: () {
              context.push('/profile/delete-account');
            },
          ),
          const Divider(),
          // Logout
          SettingsItem(
            icon: Icons.logout,
            title: 'Logout',
            iconColor: Colors.red,
            titleColor: Colors.red,
            onTap: () {
              _showLogoutConfirmation(context);
            },
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(languageProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, ref, 'English', const Locale('en', '')),
            _buildLanguageOption(context, ref, 'Hausa', const Locale('ha', '')),
            _buildLanguageOption(context, ref, 'Yoruba', const Locale('yo', '')),
            _buildLanguageOption(context, ref, 'Igbo', const Locale('ig', '')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDonationGoalSetter(BuildContext context, WidgetRef ref) {
    final currentGoal = ref.read(donationGoalProvider);
    final currentYear = ref.read(donationGoalYearProvider);

    int tempGoal = currentGoal;
    int tempYear = currentYear;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Donation Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set a target for how many times you want to donate blood in a year. You\'ll earn points for each donation and can redeem rewards when you reach your goal!',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Donations: '),
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Slider(
                        value: tempGoal.toDouble(),
                        min: 1,
                        max: 6,
                        divisions: 5,
                        label: tempGoal.toString(),
                        onChanged: (value) {
                          setState(() {
                            tempGoal = value.toInt();
                          });
                        },
                      );
                    },
                  ),
                ),
                Text(tempGoal.toString()),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Year: '),
                StatefulBuilder(
                  builder: (context, setState) {
                    return DropdownButton<int>(
                      value: tempYear,
                      items: [
                        for (int year = DateTime.now().year; year <= DateTime.now().year + 3; year++)
                          DropdownMenuItem(
                            value: year,
                            child: Text(year.toString()),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            tempYear = value;
                          });
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'You\'ll earn 50 points for each donation and a 100 point bonus for reaching your goal!',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(donationGoalEnabledProvider.notifier).state = false;
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(donationGoalProvider.notifier).state = tempGoal;
              ref.read(donationGoalYearProvider.notifier).state = tempYear;
              Navigator.pop(context);
            },
            child: const Text('Set Goal'),
          ),
        ],
      ),
    );
  }

  void _showRewardsDialog(BuildContext context, WidgetRef ref) {
    final points = ref.read(donationPointsProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.card_giftcard,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            const Text('Your Rewards'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Points: $points',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Available Rewards:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildRewardItem(
              context,
              'Free Coffee at Café Kano',
              100,
              points >= 100,
            ),
            _buildRewardItem(
              context,
              '15% Discount at Kano Pharmacy',
              200,
              points >= 200,
            ),
            _buildRewardItem(
              context,
              'Movie Ticket at Kano Cinema',
              300,
              points >= 300,
            ),
            _buildRewardItem(
              context,
              'Free Health Checkup',
              500,
              points >= 500,
            ),
            const SizedBox(height: 10),
            const Text(
              'Visit any partner store to redeem your rewards. Show your QR code from the app to claim your reward.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to QR code screen
            },
            child: const Text('Show QR Code'),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem(BuildContext context, String title, int pointsRequired, bool isAvailable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            isAvailable ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isAvailable ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isAvailable ? Colors.black : Colors.grey,
                fontWeight: isAvailable ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isAvailable
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$pointsRequired pts',
              style: TextStyle(
                fontSize: 12,
                color: isAvailable ? Colors.green : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, WidgetRef ref, String language, Locale locale) {
    final currentLocale = ref.read(languageProvider);
    final isSelected = currentLocale.languageCode == locale.languageCode;

    return ListTile(
      title: Text(language),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        ref.read(languageProvider.notifier).setLocale(locale);
        Navigator.pop(context);
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;
  final bool isDarkMode;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.titleColor,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor ?? (isDarkMode ? Colors.grey[300] : Colors.grey[600]),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? (isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

