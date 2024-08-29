import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/client/users.dart';
import '../../../../service/firebase/firestore_user.dart';

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  // Function to set the user data
  void setUser(UserModel user) {
    state = user;
  }

  // Function to clear the user data
  void clearUser() {
    state = null;
  }

  // Function to fetch the user data from Firestore and set it
  Future<void> fetchUser(String userId) async {
    final userData = await FirestoreUser().getUserById(userId);
    if (userData != null) {
      setUser(userData);
    }
  }
}

// Provider to access the UserNotifier
final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});

// State provider to manage the expansion of the NavigationRail
final isNavigationRailExpandedProvider = StateProvider<bool>((ref) => true);

// Add any other providers related to navigation or UI state here
final isSettingsExpandedProvider = StateProvider<bool>((ref) => false);

final selectedProfileSectionProvider =
    StateProvider<String>((ref) => 'Profile');

// You can add more providers as needed
