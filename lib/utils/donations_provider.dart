import 'package:flutter_riverpod/flutter_riverpod.dart';

// Models
class Donation {
  final String id;
  final String center;
  final DateTime dateTime;
  final String status;
  final int amount;

  Donation({
    required this.id,
    required this.center,
    required this.dateTime,
    required this.status,
    required this.amount,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'] as String,
      center: json['center'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      status: json['status'] as String,
      amount: json['amount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'center': center,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'amount': amount,
    };
  }
}

// State
class DonationsState {
  final List<Donation> donations;
  final Donation? nextDonation;
  final bool isLoading;
  final String? error;
  final DonationStats stats;

  DonationsState({
    required this.donations,
    this.nextDonation,
    this.isLoading = false,
    this.error,
    required this.stats,
  });

  DonationsState copyWith({
    List<Donation>? donations,
    Donation? nextDonation,
    bool? isLoading,
    String? error,
    DonationStats? stats,
  }) {
    return DonationsState(
      donations: donations ?? this.donations,
      nextDonation: nextDonation ?? this.nextDonation,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stats: stats ?? this.stats,
    );
  }
}

class DonationStats {
  final int totalDonations;
  final int totalAmount;
  final int livesSaved;

  DonationStats({
    required this.totalDonations,
    required this.totalAmount,
    required this.livesSaved,
  });

  DonationStats copyWith({
    int? totalDonations,
    int? totalAmount,
    int? livesSaved,
  }) {
    return DonationStats(
      totalDonations: totalDonations ?? this.totalDonations,
      totalAmount: totalAmount ?? this.totalAmount,
      livesSaved: livesSaved ?? this.livesSaved,
    );
  }
}

// Provider
final donationsProvider = StateNotifierProvider<DonationsNotifier, DonationsState>((ref) {
  return DonationsNotifier();
});

// Notifier
class DonationsNotifier extends StateNotifier<DonationsState> {
  DonationsNotifier()
      : super(DonationsState(
          donations: [],
          stats: DonationStats(
            totalDonations: 0,
            totalAmount: 0,
            livesSaved: 0,
          ),
        ));

  Future<void> loadDonations() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final donations = [
        Donation(
          id: '1',
          center: 'Kano State Hospital',
          dateTime: DateTime.now().add(const Duration(days: 15)),
          status: 'scheduled',
          amount: 450,
        ),
        Donation(
          id: '2',
          center: 'Kano State Hospital',
          dateTime: DateTime.now().subtract(const Duration(days: 15)),
          status: 'completed',
          amount: 450,
        ),
        Donation(
          id: '3',
          center: 'Aminu Kano Teaching Hospital',
          dateTime: DateTime.now().subtract(const Duration(days: 45)),
          status: 'completed',
          amount: 450,
        ),
      ];

      final stats = _calculateStats(donations);
      final nextDonation = _findNextDonation(donations);

      state = state.copyWith(
        donations: donations,
        nextDonation: nextDonation,
        stats: stats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load donations: ${e.toString()}',
      );
    }
  }

  Future<void> scheduleDonation(String center, DateTime dateTime) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final newDonation = Donation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        center: center,
        dateTime: dateTime,
        status: 'scheduled',
        amount: 450,
      );

      final updatedDonations = [...state.donations, newDonation];
      final stats = _calculateStats(updatedDonations);
      final nextDonation = _findNextDonation(updatedDonations);

      state = state.copyWith(
        donations: updatedDonations,
        nextDonation: nextDonation,
        stats: stats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to schedule donation: ${e.toString()}',
      );
    }
  }

  Future<void> cancelDonation(String donationId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedDonations = state.donations
          .where((donation) => donation.id != donationId)
          .toList();

      final stats = _calculateStats(updatedDonations);
      final nextDonation = _findNextDonation(updatedDonations);

      state = state.copyWith(
        donations: updatedDonations,
        nextDonation: nextDonation,
        stats: stats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to cancel donation: ${e.toString()}',
      );
    }
  }

  DonationStats _calculateStats(List<Donation> donations) {
    final completedDonations = donations.where((d) => d.status == 'completed').toList();
    final totalAmount = completedDonations.fold<int>(0, (sum, d) => sum + d.amount);
    
    return DonationStats(
      totalDonations: completedDonations.length,
      totalAmount: totalAmount,
      livesSaved: completedDonations.length * 3, // Assuming each donation saves 3 lives
    );
  }

  Donation? _findNextDonation(List<Donation> donations) {
    final scheduledDonations = donations
        .where((d) => d.status == 'scheduled' && d.dateTime.isAfter(DateTime.now()))
        .toList();
    
    if (scheduledDonations.isEmpty) return null;
    
    scheduledDonations.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return scheduledDonations.first;
  }
}

