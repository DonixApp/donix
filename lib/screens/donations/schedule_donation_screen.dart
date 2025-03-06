import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../utils/donations_provider.dart';

class ScheduleDonationScreen extends ConsumerStatefulWidget {
  const ScheduleDonationScreen({super.key});

  @override
  ConsumerState<ScheduleDonationScreen> createState() =>
      _ScheduleDonationScreenState();
}

class _ScheduleDonationScreenState extends ConsumerState<ScheduleDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedCenter = 'Kano State Hospital';
  final List<String> _donationCenters = [
    'Kano State Hospital',
    'Aminu Kano Teaching Hospital',
    'Murtala Muhammad Specialist Hospital',
    'National Blood Transfusion Service'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 16.0;

    Widget content = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isTablet ? 12 : 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: Theme.of(context).primaryColor,
                          size: isTablet ? 28 : 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'You are eligible to donate blood',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 24 : 16),
                  Text(
                    'Please make sure you:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  _buildRequirement(
                    'Are well-rested and had a meal',
                    isTablet,
                  ),
                  _buildRequirement(
                    'Haven\'t consumed alcohol in \n24 hours',
                    isTablet,
                  ),
                  _buildRequirement(
                    'Bring a valid ID',
                    isTablet,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isTablet ? 32 : 24),

          // Donation Center Selection
          Text(
            'Select Donation Center',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: isTablet ? 20 : null,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCenter,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 11,
                vertical: isTablet ? 20 : 13,
              ),
            ),
            items: _donationCenters.map((String center) {
              return DropdownMenuItem<String>(
                value: center,
                child: Text(
                  center,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCenter = newValue!;
              });
            },
          ),
          SizedBox(height: isTablet ? 32 : 24),

          // Date Selection
          Text(
            'Select Date',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: isTablet ? 20 : null,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: isTablet ? 20 : 16,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
                    size: isTablet ? 24 : 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _selectedDate == null
                        ? 'Select a date'
                        : DateFormat('EEEE, MMMM d, y').format(_selectedDate!),
                    style: TextStyle(
                      color: _selectedDate == null
                          ? Colors.grey[600]
                          : Colors.black,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isTablet ? 32 : 24),

          // Time Selection
          Text(
            'Select Time',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: isTablet ? 20 : null,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _selectTime(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: isTablet ? 20 : 16,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Theme.of(context).primaryColor,
                    size: isTablet ? 24 : 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _selectedTime == null
                        ? 'Select a time'
                        : _selectedTime!.format(context),
                    style: TextStyle(
                      color:
                      _selectedTime == null ? Colors.grey[600] : Colors.black,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isTablet ? 40 : 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _selectedDate != null &&
                    _selectedTime != null) {
                  _showConfirmationDialog(isTablet);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 20 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Schedule Donation',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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
          'Schedule Donation',
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 16,
        ),
        child: content,
      ),
    );
  }

  Widget _buildRequirement(String text, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 12 : 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green[600],
            size: isTablet ? 24 : 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(bool isTablet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Donation Schedule',
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Center: $_selectedCenter',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                'Date: ${DateFormat('EEEE, MMMM d, y').format(_selectedDate!)}',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                'Time: ${_selectedTime!.format(context)}',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final dateTime = DateTime(
                  _selectedDate!.year,
                  _selectedDate!.month,
                  _selectedDate!.day,
                  _selectedTime!.hour,
                  _selectedTime!.minute,
                );

                await ref.read(donationsProvider.notifier).scheduleDonation(
                  _selectedCenter,
                  dateTime,
                );

                if (mounted) {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context, true); // Return to previous screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Donation scheduled successfully!',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 16,
                  vertical: isTablet ? 12 : 8,
                ),
              ),
              child: Text(
                'Confirm',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
            ),
          ],
          contentPadding: EdgeInsets.all(isTablet ? 24 : 16),
          actionsPadding: EdgeInsets.all(isTablet ? 16 : 8),
        );
      },
    );
  }
}

