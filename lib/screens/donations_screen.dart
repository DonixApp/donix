import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:donix/screens/donations/schedule_donation_screen.dart';
import 'package:donix/utils/donations_provider.dart';
import '../utils/theme_notifier.dart';
import '../widgets/settings_section.dart';

class DonationsScreen extends ConsumerStatefulWidget {
  const DonationsScreen({super.key});

  @override
  ConsumerState<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends ConsumerState<DonationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(donationsProvider.notifier).loadDonations());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(donationsProvider);
    final isDarkMode = ref.watch(themeProvider);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final donationPoints = ref.watch(donationPointsProvider);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  state.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(donationsProvider.notifier).loadDonations();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget content = RefreshIndicator(
      onRefresh: () => ref.read(donationsProvider.notifier).loadDonations(),
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? size.width * 0.1 : 16,
          vertical: 16,
        ),
        children: [
          // Rewards Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Donation Rewards',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: isTablet ? 24 : null,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$donationPoints pts',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 16 : 12),

                  // Donation Goal Progress
                  if (ref.watch(donationGoalEnabledProvider)) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Goal: ${state.stats.totalDonations} of ${ref.watch(donationGoalProvider)} donations in ${ref.watch(donationGoalYearProvider)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                        Text(
                          '${((state.stats.totalDonations / ref.watch(donationGoalProvider)) * 100).toInt()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (state.stats.totalDonations / ref.watch(donationGoalProvider)).clamp(0.0, 1.0),
                        backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                        minHeight: 8,
                      ),
                    ),
                    if (state.stats.totalDonations >= ref.watch(donationGoalProvider))
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Goal achieved! You\'ve earned a 100 point bonus!',
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ] else ...[
                    Text(
                      'Set a donation goal in settings to earn bonus points!',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ],

                  SizedBox(height: isTablet ? 16 : 12),

                  // Redeem Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showRewardsDialog(context, donationPoints),
                      icon: const Icon(Icons.card_giftcard),
                      label: const Text('Redeem Rewards'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 16 : 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isTablet ? 24 : 16),

          // Donation Stats Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Donation Statistics',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: isTablet ? 24 : null,
                    ),
                  ),
                  SizedBox(height: isTablet ? 24 : 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            context,
                            state.stats.totalDonations.toString(),
                            'Total\nDonations',
                            Icons.favorite,
                            Colors.red,
                            isTablet,
                          ),
                          _buildStatItem(
                            context,
                            '${state.stats.totalAmount}ml',
                            'Blood\nDonated',
                            Icons.water_drop,
                            Colors.blue,
                            isTablet,
                          ),
                          _buildStatItem(
                            context,
                            state.stats.livesSaved.toString(),
                            'Lives\nSaved',
                            Icons.people,
                            Colors.green,
                            isTablet,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isTablet ? 32 : 24),

          // Upcoming Donation
          if (state.nextDonation != null) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).primaryColor,
                          size: isTablet ? 28 : 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Next Scheduled Donation',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: isTablet ? 20 : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 24 : 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 400) {
                          // Mobile layout
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.nextDonation!.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('MMMM d, y • h:mm a')
                                    .format(state.nextDonation!.dateTime),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        ref
                                            .read(donationsProvider.notifier)
                                            .cancelDonation(
                                            state.nextDonation!.id);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: Show donation details
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        Theme.of(context).primaryColor,
                                      ),
                                      child: const Text('View Details'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }

                        // Tablet/Desktop layout
                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.nextDonation!.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: isTablet ? 18 : 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMMM d, y • h:mm a')
                                        .format(state.nextDonation!.dateTime),
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    ref
                                        .read(donationsProvider.notifier)
                                        .cancelDonation(state.nextDonation!.id);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: Show donation details
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Theme.of(context).primaryColor,
                                  ),
                                  child: const Text('View Details'),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isTablet ? 32 : 24),
          ],

          // Donation History
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Donation History',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: isTablet ? 24 : null,
                ),
              ),
              // Points per donation info
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You earn 50 points for each donation!'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Colors.amber,
                ),
                label: const Text(
                  'Points Info',
                  style: TextStyle(
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
            state.donations.where((d) => d.status == 'completed').length,
            itemBuilder: (context, index) {
              final donation = state.donations
                  .where((d) => d.status == 'completed')
                  .toList()[index];
              return Card(
                margin: EdgeInsets.only(
                  bottom: isTablet ? 16 : 12,
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(isTablet ? 20 : 16),
                  leading: CircleAvatar(
                    radius: isTablet ? 28 : 24,
                    backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.favorite,
                      color: Theme.of(context).primaryColor,
                      size: isTablet ? 28 : 24,
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          donation.center,
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Points badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '+50 pts',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${DateFormat('MMMM d, y').format(donation.dateTime)} • ${donation.amount}ml',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: isTablet ? 16 : null,
                    ),
                  ),
                  trailing: Chip(
                    label: const Text('Completed'),
                    backgroundColor: Colors.green[100],
                    labelStyle: TextStyle(
                      color: Colors.green,
                      fontSize: isTablet ? 14 : 12,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 12 : 8,
                      vertical: isTablet ? 8 : 4,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );

    // For tablets, wrap content in a constrained width container
    if (isTablet) {
      content = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: content,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Donations',
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
      ),
      body: content,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScheduleDonationScreen(),
            ),
          );
          if (result != null) {
            // Handle the scheduled donation
            ref.read(donationsProvider.notifier).loadDonations();
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(
          Icons.add,
          size: isTablet ? 28 : 24,
        ),
        label: Text(
          'Schedule Donation',
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context,
      String value,
      String label,
      IconData icon,
      Color color,
      bool isTablet,
      ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: isTablet ? 32 : 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 32 : 24,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: isTablet ? 14 : 12,
          ),
        ),
      ],
    );
  }

  void _showRewardsDialog(BuildContext context, int points) {
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
}

