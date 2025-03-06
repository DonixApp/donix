import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            SizedBox(height: 24),
            _buildVerificationStatus(),
            SizedBox(height: 24),
            _buildSettingsSection(),
            SizedBox(height: 24),
            _buildAccountSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.grey[800],
          child: Icon(Icons.person, size: 32, color: Colors.white),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sadisu Salisu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Freemium',
                    style: TextStyle(color: Colors.blue[700], fontSize: 12),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '@sadisusalisu45568705',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerificationStatus() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Verification Status:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800]),
          ),
          Text(
            'Verified Donor',
            style: TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
        ),
        SizedBox(height: 16),
        _buildSettingItem(
          icon: Icons.notifications,
          title: 'Notifications',
          trailing: Switch(
            value: notificationsEnabled,
            onChanged: (value) => setState(() => notificationsEnabled = value),
          ),
        ),
        _buildSettingItem(icon: Icons.security, title: 'Privacy & Security'),
        _buildSettingItem(icon: Icons.location_on, title: 'Donation Centers'),
        _buildSettingItem(icon: Icons.group, title: 'Referrals'),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
        ),
        SizedBox(height: 16),
        _buildSettingItem(icon: Icons.credit_card, title: 'Manage Subscriptions'),
        _buildSettingItem(icon: Icons.help, title: 'Help & Support'),
        _buildSettingItem(
          icon: Icons.exit_to_app,
          title: 'Log Out',
          textColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(icon, color: Colors.grey[600]),
      ),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: trailing ?? Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

