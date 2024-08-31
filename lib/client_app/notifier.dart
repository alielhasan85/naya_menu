// notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/models/client/users.dart';
import 'package:naya_menu/service/firebase/firestore_user.dart';

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

  // Function to update user data locally and in Firestore
  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    if (state != null) {
      // Update Firestore with the new data
      await FirestoreUser().updateUser(state!.userId, updatedData);

      // Update the state locally
      state = state!.copyWith(
        name: updatedData['name'] ?? state!.name,
        jobTitle: updatedData['jobTitle'] ?? state!.jobTitle,
        businessName: updatedData['businessName'] ?? state!.businessName,
        // Add other fields as needed
      );
    }
  }
}

// Providers
final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});

final isNavigationRailExpandedProvider = StateProvider<bool>((ref) => true);

final isSettingsExpandedProvider = StateProvider<bool>((ref) => false);

final selectedProfileSectionProvider =
    StateProvider<String>((ref) => 'Profile');

final selectedSectionProvider = StateProvider<String>((ref) => 'Dashboard');

// Add other related providers here
