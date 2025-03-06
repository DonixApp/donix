import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/settings_section.dart';


class HistoryScreen extends ConsumerWidget {
  HistoryScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> donationHistory = [
    {'type': 'Whole Blood', 'date': 'March 1, 2024', 'amount': '450 ml', 'impact': 'Saved 3 lives', 'points': '50'},
    {'type': 'Plasma', 'date': 'December 14, 2023', 'amount': '600 ml', 'impact': 'Helped 2 patients', 'points': '50'},
    {'type': 'Platelets', 'date': 'September 5, 2023', 'amount': '200 ml', 'impact': 'Supported 1 cancer patient', 'points': '50'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final donationPoints = ref.watch(donationPointsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation History'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImpactCard(context, donationPoints),
            const SizedBox(height: 24),
            const Text(
              'Recent Donations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...donationHistory.map((donation) => _buildDonationCard(donation, context)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactCard(BuildContext context, int donationPoints) {
    final totalDonations = 15;
    final donationGoal = 20;

    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Impact',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Points display
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
            const SizedBox(height: 8),
            Text(
              '$totalDonations Donations',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 8),
            LinearPercentIndicator(
              percent: totalDonations / donationGoal,
              lineHeight: 8,
              backgroundColor: Colors.red[100],
              progressColor: Colors.red,
            ),
            const SizedBox(height: 8),
            Text(
              '${donationGoal - totalDonations} more to reach your next milestone!',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            // Redeem rewards button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showRewardsDialog(context, donationPoints),
                icon: const Icon(Icons.card_giftcard),
                label: const Text('Redeem Rewards'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationCard(Map<String, String> donation, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.opacity, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      donation['type']!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  donation['date']!,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Amount: ${donation['amount']}'),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      donation['impact']!,
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                // Points earned for this donation
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '+${donation['points']} pts',
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
          ],
        ),
      ),
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

