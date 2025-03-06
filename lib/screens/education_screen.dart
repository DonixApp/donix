import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EducationScreen extends StatelessWidget {
  final List<Map<String, String>> educationItems = [
    {
      'title': 'Why Donate Blood?',
      'description': 'Learn about the importance of blood donation in Kano.',
      'icon': 'assets/svgs/why_donate.svg', // Replace with your SVG path
    },
    {
      'title': 'Donation Process',
      'description': 'Step-by-step guide to donating blood.',
      'icon': 'assets/svgs/donation_process.svg', // Replace with your SVG path
    },
    {
      'title': 'Myths and Facts',
      'description': 'Dispelling common myths about blood donation.',
      'icon': 'assets/svgs/myths_facts.svg', // Replace with your SVG path
    },
    {
      'title': 'Eligibility Criteria',
      'description': 'Find out if you are eligible to donate blood.',
      'icon': 'assets/svgs/eligibility.svg', // Replace with your SVG path
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learn About Blood Donation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: educationItems.length,
        itemBuilder: (context, index) {
          final item = educationItems[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // Navigate to detailed education page
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    // SVG Icon
                    Container(
                      width: 60,
                      height: 60,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SvgPicture.asset(
                        item['icon']!,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: 16),
                    // Text Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            item['description']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}