import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:donix/utils/dashboard_provider.dart';
import 'package:go_router/go_router.dart';

class QuickActionsGrid extends ConsumerWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    final actions = [
      {
        'icon': Icons.favorite,
        'label': 'Donate',
        'color': Colors.red,
        'route': '/history',
      },
      {
        'icon': Icons.list_alt,
        'label': 'Requests',
        'color': Colors.orange,
        'route': '/requests',
      },
      {
        'icon': Icons.search,
        'label': 'Find Donors',
        'color': Colors.blue,
        'route': '/find',
      },
      {
        'icon': Icons.school,
        'label': 'Learn',
        'color': Colors.green,
        'route': '/learn',
      },
      {
        'icon': Icons.people,
        'label': 'Community',
        'color': Colors.purple,
        'route': '/community',
      },
      {
        'icon': Icons.chat_bubble,
        'label': 'Chatbot',
        'color': Colors.teal,
        'route': '/chatbot',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600 ? 24 : 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 6 : 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return InkWell(
              onTap: () => context.push(action['route'] as String),
              borderRadius: BorderRadius.circular(12),
              child: Semantics(
                button: true,
                label: '${action['label']} button',
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (action['color'] as Color).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (action['color'] as Color).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: action['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        action['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

