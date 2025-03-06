import 'package:flutter/material.dart';
import '../utils/theme_notifier.dart';

class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Kano Blood Donation Community'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Events'),
              Tab(text: 'Stories'),
              Tab(text: 'Leaderboard'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEventsTab(),
            _buildStoriesTab(),
            _buildLeaderboardTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsTab() {
    return ListView(
      children: [
        _buildEventCard(
          'Blood Donation Drive',
          'Kano State Hospital',
          'May 15, 2024',
          '9:00 AM - 4:00 PM',
        ),
        _buildEventCard(
          'Community Awareness Program',
          'Kano City Center',
          'May 20, 2024',
          '10:00 AM - 2:00 PM',
        ),
      ],
    );
  }

  Widget _buildEventCard(String title, String location, String date, String time) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location),
            Text('$date • $time'),
          ],
        ),
        trailing: ElevatedButton(
          child: Text('Join'),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildStoriesTab() {
    return ListView(
      children: [
        _buildStoryCard(
          'Amina\'s Story',
          'How blood donation saved my life during childbirth.',
          'assets/icons/blood_drop.svg',
        ),
        _buildStoryCard(
          'Hassan\'s Journey',
          'From recipient to regular donor: My blood donation journey.',
          'assets/icons/logo.svg',
        ),
      ],
    );
  }

  Widget _buildStoryCard(String title, String description, String imagePath) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.asset(imagePath, height: 200, width: double.infinity, fit: BoxFit.cover),
          ListTile(
            title: Text(title),
            subtitle: Text(description),
            trailing: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return ListView(
      children: [
        ListTile(
          leading: CircleAvatar(child: Text('1')),
          title: Text('Ibrahim Musa'),
          subtitle: Text('50 donations'),
          trailing: Icon(Icons.emoji_events, color: Colors.amber),
        ),
        ListTile(
          leading: CircleAvatar(child: Text('2')),
          title: Text('Fatima Abubakar'),
          subtitle: Text('45 donations'),
          trailing: Icon(Icons.emoji_events, color: Colors.grey[400]),
        ),
        ListTile(
          leading: CircleAvatar(child: Text('3')),
          title: Text('Yusuf Abdullahi'),
          subtitle: Text('40 donations'),
          trailing: Icon(Icons.emoji_events, color: Colors.brown[300]),
        ),
      ],
    );
  }
}

