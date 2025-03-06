import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final String? userName;
  final String? bloodType;
  final String? profileImageUrl;
  final bool isAuthenticated;

  AuthState({
    this.userName,
    this.bloodType,
    this.profileImageUrl,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    String? userName,
    String? bloodType,
    String? profileImageUrl,
    bool? isAuthenticated,
  }) {
    return AuthState(
      userName: userName ?? this.userName,
      bloodType: bloodType ?? this.bloodType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void setUserData({
    String? userName,
    String? bloodType,
    String? profileImageUrl,
  }) {
    state = state.copyWith(
      userName: userName,
      bloodType: bloodType,
      profileImageUrl: profileImageUrl,
      isAuthenticated: true,
    );
  }

  void clearUserData() {
    state = AuthState();
  }
}

