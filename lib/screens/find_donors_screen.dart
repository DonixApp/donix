import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/theme_notifier.dart';
import '../utils/navigation_service.dart';
import 'package:go_router/go_router.dart';

// Donor model class defined within the same file
class Donor {
  final String id;
  final String name;
  final String bloodType;
  final String lastDonation;
  final String distance;
  final int donationCount;
  final bool isVerified;

  Donor({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.lastDonation,
    required this.distance,
    this.donationCount = 0,
    this.isVerified = false,
  });
}

// Providers for donor filtering and search
final donorSearchProvider = StateProvider<String>((ref) => '');
final selectedBloodTypeProvider = StateProvider<String?>((ref) => null);
final distanceFilterProvider = StateProvider<double>((ref) => 10.0);
final lastDonationFilterProvider = StateProvider<int>((ref) => 0);

// Dummy data for donors
final dummyDonors = [
  Donor(
    id: '1',
    name: 'Aisha Mohammed',
    bloodType: 'A+',
    lastDonation: '2 months ago',
    distance: '2.5 km',
    donationCount: 5,
    isVerified: true,
  ),
  Donor(
    id: '2',
    name: 'Bashir Yusuf',
    bloodType: 'O-',
    lastDonation: '3 months ago',
    distance: '3.8 km',
    donationCount: 3,
    isVerified: true,
  ),
  Donor(
    id: '3',
    name: 'Fatima Ibrahim',
    bloodType: 'B+',
    lastDonation: '1 month ago',
    distance: '1.2 km',
    donationCount: 7,
    isVerified: true,
  ),
  Donor(
    id: '4',
    name: 'Mohammed Ali',
    bloodType: 'AB+',
    lastDonation: '5 months ago',
    distance: '4.1 km',
    donationCount: 2,
    isVerified: false,
  ),
  Donor(
    id: '5',
    name: 'Zainab Hassan',
    bloodType: 'O+',
    lastDonation: '2 weeks ago',
    distance: '0.8 km',
    donationCount: 10,
    isVerified: true,
  ),
];

// Filtered donors provider
final filteredDonorsProvider = Provider<List<Donor>>((ref) {
  final searchQuery = ref.watch(donorSearchProvider).toLowerCase();
  final selectedBloodType = ref.watch(selectedBloodTypeProvider);

  return dummyDonors.where((donor) {
    final matchesSearch = donor.name.toLowerCase().contains(searchQuery) ||
        donor.bloodType.toLowerCase().contains(searchQuery);
    final matchesBloodType = selectedBloodType == null || donor.bloodType == selectedBloodType;
    return matchesSearch && matchesBloodType;
  }).toList();
});

class FindDonorsScreen extends ConsumerStatefulWidget {
  const FindDonorsScreen({super.key});

  @override
  ConsumerState<FindDonorsScreen> createState() => _FindDonorsScreenState();
}

class _FindDonorsScreenState extends ConsumerState<FindDonorsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  bool _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen to search changes
    _searchController.addListener(() {
      ref.read(donorSearchProvider.notifier).state = _searchController.text;
    });

    // Simulate checking location permission
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _hasLocationPermission = true;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final filteredDonors = ref.watch(filteredDonorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Donors'),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context, isDarkMode),
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Map view coming soon!')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: isDarkMode ? Colors.white : Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.red,
          tabs: const [
            Tab(text: 'Nearby Donors'),
            Tab(text: 'Donation Centers'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar with location indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search donors or blood type',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(donorSearchProvider.notifier).state = '';
                        },
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: _hasLocationPermission
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.location_on,
                    color: _hasLocationPermission ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // Blood type filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: const Text('All'),
                      selected: ref.watch(selectedBloodTypeProvider) == null,
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(selectedBloodTypeProvider.notifier).state = null;
                        }
                      },
                      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      selectedColor: Colors.red.withOpacity(0.2),
                      checkmarkColor: Colors.red,
                    ),
                  ),
                  ..._bloodTypes.map((type) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type),
                      selected: ref.watch(selectedBloodTypeProvider) == type,
                      onSelected: (selected) {
                        ref.read(selectedBloodTypeProvider.notifier).state = selected ? type : null;
                      },
                      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      selectedColor: Colors.red.withOpacity(0.2),
                      checkmarkColor: Colors.red,
                    ),
                  )).toList(),
                ],
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Nearby Donors Tab
                filteredDonors.isEmpty
                    ? _buildEmptyState(isDarkMode)
                    : ListView.builder(
                  itemCount: filteredDonors.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final donor = filteredDonors[index];
                    return _buildDonorCard(donor, isDarkMode);
                  },
                ),

                // Donation Centers Tab
                _buildDonationCentersTab(isDarkMode),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/blood-request'),
        backgroundColor: Colors.red,
        label: const Text('Request Blood'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No donors found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: isDarkMode ? Colors.white60 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonorCard(Donor donor, bool isDarkMode) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showDonorDetails(context, donor, isDarkMode),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.red.withOpacity(0.1),
                child: Text(
                  donor.bloodType,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          donor.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        if (donor.isVerified)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.verified,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last donation: ${donor.lastDonation}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${donor.donationCount} donations',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      donor.distance,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _showDonorDetails(context, donor, isDarkMode),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Contact',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonationCentersTab(bool isDarkMode) {
    // This would be populated with actual donation centers
    return ListView.builder(
      itemCount: 3,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_hospital,
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kano Blood Center ${index + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${3.5 + index * 1.2} km away',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Open',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCenterAction(
                      icon: Icons.directions,
                      label: 'Directions',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Directions feature coming soon!')),
                        );
                      },
                    ),
                    _buildCenterAction(
                      icon: Icons.phone,
                      label: 'Call',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Call feature coming soon!')),
                        );
                      },
                    ),
                    _buildCenterAction(
                      icon: Icons.calendar_today,
                      label: 'Schedule',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Schedule feature coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCenterAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.red),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Donors',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Distance',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, _) {
                  final distance = ref.watch(distanceFilterProvider);
                  return Column(
                    children: [
                      Slider(
                        value: distance,
                        min: 1,
                        max: 50,
                        divisions: 49,
                        label: '${distance.round()} km',
                        activeColor: Colors.red,
                        onChanged: (value) {
                          ref.read(distanceFilterProvider.notifier).state = value;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('1 km'),
                          Text('${distance.round()} km'),
                          const Text('50 km'),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Last Donation',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, _) {
                  final lastDonation = ref.watch(lastDonationFilterProvider);
                  return Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip('Any time', 0, lastDonation, ref),
                      _buildFilterChip('< 1 month', 1, lastDonation, ref),
                      _buildFilterChip('< 3 months', 3, lastDonation, ref),
                      _buildFilterChip('< 6 months', 6, lastDonation, ref),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Apply filters
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Filters applied')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, int value, int selectedValue, WidgetRef ref) {
    return FilterChip(
      label: Text(label),
      selected: selectedValue == value,
      onSelected: (selected) {
        if (selected) {
          ref.read(lastDonationFilterProvider.notifier).state = value;
        }
      },
      selectedColor: Colors.red.withOpacity(0.2),
      checkmarkColor: Colors.red,
    );
  }

  void _showDonorDetails(BuildContext context, Donor donor, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red.withOpacity(0.1),
                    child: Text(
                      donor.bloodType,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          donor.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Verified Donor',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Donor Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(Icons.water_drop, 'Blood Type: ${donor.bloodType}', isDarkMode),
              const SizedBox(height: 12),
              _buildDetailRow(
                  Icons.calendar_today, 'Last Donation: ${donor.lastDonation}', isDarkMode),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.location_on, 'Distance: ${donor.distance}', isDarkMode),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.verified_user, 'Donations: ${donor.donationCount} times', isDarkMode),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Contact Options',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.phone, color: Colors.white),
                      label: const Text(
                        'Call',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Calling donor...')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.message, color: Colors.red),
                      label: const Text(
                        'Message',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Messaging donor...')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.share, color: Colors.red),
                  label: const Text(
                    'Share Donor Profile',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sharing donor profile...')),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String text, bool isDarkMode) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }
}

