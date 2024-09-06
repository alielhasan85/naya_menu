import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/models/client/users.dart';
import 'package:naya_menu/models/venue/venue.dart';
import 'package:naya_menu/service/firebase/firestore_user.dart';
import 'package:naya_menu/service/firebase/firestore_venue.dart';

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

class VenueNotifier extends StateNotifier<VenueModel?> {
  VenueNotifier() : super(null);

  // Function to set the venue data
  void setVenue(VenueModel venue) {
    state = venue;
  }

  // Function to clear the venue data
  void clearVenue() {
    state = null;
  }

  // Function to fetch the venue data from Firestore and set it
  Future<void> fetchVenue(String userId, String venueId) async {
    final venueData = await FirestoreVenue().getVenueById(userId, venueId);
    if (venueData != null) {
      setVenue(venueData);
    }
  }

  // Function to update venue data locally and in Firestore
  Future<void> updateVenueData(
      String userId, String venueId, Map<String, dynamic> updatedData) async {
    if (state != null) {
      // Update Firestore with the new data
      await FirestoreVenue().updateVenue(userId, venueId, updatedData);

      // Update the state locally
      state = state!.copyWith(
        venueName: updatedData['venueName'] ?? state!.venueName,
        address: updatedData['address'] ?? state!.address,
        contact: updatedData['contact'] ?? state!.contact,
        // Add other fields as needed
      );
    }
  }
}

// Providers
final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});

final venueProvider = StateNotifierProvider<VenueNotifier, VenueModel?>((ref) {
  return VenueNotifier();
});

final venueListProvider = FutureProvider<List<VenueModel>>((ref) async {
  final user = ref.read(userProvider);
  if (user != null) {
    return FirestoreVenue().getAllVenues(user.userId);
  }
  return [];
});

final isNavigationRailExpandedProvider = StateProvider<bool>((ref) => true);

final isSettingsExpandedProvider = StateProvider<bool>((ref) => false);

final selectedProfileSectionProvider =
    StateProvider<String>((ref) => 'Profile');

final selectedSectionProvider = StateProvider<String>((ref) => 'Dashboard');

// Add other related providers here
