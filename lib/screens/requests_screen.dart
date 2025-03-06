import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Requests'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Incoming'),
            Tab(text: 'Outgoing'),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const BackgroundPattern(),
          SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRequestsList(incomingRequests, true),
                _buildRequestsList(outgoingRequests, false),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/blood-request'),
        label: const Text('New Request'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFFE53935),
      ),
    );
  }

  Widget _buildRequestsList(List<Map<String, String>> requests, bool isIncoming) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isIncoming ? Icons.inbox : Icons.outbox,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isIncoming ? 'No incoming requests' : 'No outgoing requests',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isIncoming
                  ? 'Requests from donors will appear here'
                  : 'Your blood requests will appear here',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: requests.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showRequestDetails(context, request),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _getColorForBloodType(request['bloodType']!).withOpacity(0.2),
                        child: Text(
                          request['bloodType']!,
                          style: TextStyle(
                            color: _getColorForBloodType(request['bloodType']!),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request['name']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(request['date']!),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      isIncoming
                          ? Chip(
                        label: Text(
                          request['urgency']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: _getUrgencyColor(request['urgency']!),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )
                          : Chip(
                        label: Text(
                          request['status']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: _getStatusColor(request['status']!),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          request['location']!,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _showRequestDetails(context, request),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('View Details'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getColorForBloodType(String bloodType) {
    switch (bloodType) {
      case 'A+':
      case 'A-':
        return const Color(0xFFE53935);
      case 'B+':
      case 'B-':
        return const Color(0xFF1E88E5);
      case 'AB+':
      case 'AB-':
        return const Color(0xFF8E24AA);
      case 'O+':
      case 'O-':
        return const Color(0xFFFB8C00);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'high':
        return const Color(0xFFE53935);
      case 'medium':
        return const Color(0xFFFB8C00);
      case 'low':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFB8C00);
      case 'approved':
        return const Color(0xFF4CAF50);
      case 'rejected':
        return const Color(0xFFE53935);
      case 'completed':
        return const Color(0xFF1E88E5);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  void _showRequestDetails(BuildContext context, Map<String, String> request) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: _getColorForBloodType(request['bloodType']!).withOpacity(0.2),
                child: Text(
                  request['bloodType']!,
                  style: TextStyle(
                    color: _getColorForBloodType(request['bloodType']!),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Blood Request Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(Icons.person, 'Patient', request['name']!),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.water_drop, 'Blood Type', request['bloodType']!),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.location_on, 'Hospital', request['location']!),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.calendar_today, 'Date', _formatDate(request['date']!)),
              const SizedBox(height: 12),
              if (request['urgency'] != null)
                _buildDetailRow(Icons.priority_high, 'Urgency', request['urgency']!),
              if (request['status'] != null)
                _buildDetailRow(Icons.info, 'Status', request['status']!),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => context.pop(),
            ),
            ElevatedButton(
              child: const Text('Respond'),
              onPressed: () {
                // TODO: Implement response logic
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFFFFF),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  final List<Map<String, String>> incomingRequests = [
    {
      'name': 'Aminu Yusuf',
      'bloodType': 'A+',
      'location': 'Aminu Kano Teaching Hospital',
      'urgency': 'High',
      'date': '2024-05-10'
    },
    {
      'name': 'Fatima Ibrahim',
      'bloodType': 'O-',
      'location': 'Murtala Muhammad Specialist Hospital',
      'urgency': 'Medium',
      'date': '2024-05-12'
    },
  ];

  final List<Map<String, String>> outgoingRequests = [
    {
      'name': 'Aisha Mohammed',
      'bloodType': 'B+',
      'location': 'Abdullahi Wase Specialist Hospital',
      'status': 'Pending',
      'date': '2024-05-08'
    },
  ];
}

class BackgroundPattern extends StatelessWidget {
  const BackgroundPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'), // Replace with your actual asset path
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

