import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naya_menu/models/venue/venue.dart';
import 'package:naya_menu/models/client/users.dart'; // Import the user model

class FirestoreVenue {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new venue to a specific user's document in Firestore
  Future<String> addVenue(String userId, VenueModel venue) async {
    final venuesCollection =
        _firestore.collection('users').doc(userId).collection('venues');

    // Generate a new document ID
    DocumentReference venueDoc = venuesCollection.doc();
    venue = venue.copyWith(venueId: venueDoc.id);

    await venueDoc.set(venue.toMap());

    // Return the newly created venue ID
    return venueDoc.id;
  }

  // Create a default venue when a user account is created
  Future<void> createDefaultVenue(UserModel user) async {
    try {
      VenueModel defaultVenue = VenueModel(
        venueId: '', // Empty string, Firestore will generate the ID
        venueName: user.businessName, // Default venue name from user
        userId: user.userId, // Pass the userId from the UserModel
        logoUrl: '', // Default empty URL for logo
        address: {
          'country': user.country,
        },
        contact: {
          'email': user.email,
          'phoneNumber': user.phoneNumber,
        },
        // Additional fields can be left as default or set as required
        socialAccounts: {},
        operations: {},
        qrCodes: {},
        designAndDisplay: {},
        priceOptions: {},
      );

      // Add the venue using the addVenue method
      await addVenue(user.userId, defaultVenue);

      print('Default venue created successfully');
    } catch (e) {
      print('Error creating default venue: $e');
      // Handle error (e.g., show a message to the user)
    }
  }

  // Update specific fields of a venue by its [venueId] for a specific user
  Future<void> updateVenue(
      String userId, String venueId, Map<String, dynamic> updatedData) async {
    final venueDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId);

    await venueDoc.update(updatedData);
  }

  // Delete a venue from Firestore by its [venueId] for a specific user
  Future<void> deleteVenue(String userId, String venueId) async {
    final venueDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId);

    await venueDoc.delete();
  }

  // Retrieve a specific venue's data by its [venueId] for a specific user
  Future<VenueModel?> getVenueById(String userId, String venueId) async {
    final venueDoc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId)
        .get();

    if (venueDoc.exists) {
      return VenueModel.fromMap(
          venueDoc.data() as Map<String, dynamic>, venueDoc.id);
    }

    return null;
  }

  // Retrieve a list of all venues for a specific user
  Future<List<VenueModel>> getAllVenues(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .get();

    return querySnapshot.docs
        .map((doc) =>
            VenueModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Update venue's address field specifically
  Future<void> updateVenueAddress(
      String userId, String venueId, Map<String, dynamic> address) async {
    final venueDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId);

    await venueDoc.update({'address': address});
  }

  // Add or update social accounts for a venue
  Future<void> updateVenueSocialAccounts(
      String userId, String venueId, Map<String, String> socialAccounts) async {
    final venueDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId);

    await venueDoc.update({'socialAccounts': socialAccounts});
  }

  // Update design and display settings for a venue
  Future<void> updateDesignAndDisplay(String userId, String venueId,
      Map<String, dynamic> designAndDisplay) async {
    final venueDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId);

    await venueDoc.update({'designAndDisplay': designAndDisplay});
  }

  // Update the operation settings for a venue
  Future<void> updateOperations(
      String userId, String venueId, Map<String, dynamic> operations) async {
    final venueDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId);

    await venueDoc.update({'operations': operations});
  }

  // Update price options for a venue
  Future<void> updatePriceOptions(
      String userId, String venueId, Map<String, dynamic> priceOptions) async {
    final venueDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId);

    await venueDoc.update({'priceOptions': priceOptions});
  }

  // Log changes or activities related to the venue (e.g., changes to the menu, updates to venue info)
  Future<void> logVenueActivity(
      String userId, String venueId, String activity) async {
    final venueDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId);

    await venueDoc.update({
      'recentActivities': FieldValue.arrayUnion([activity]),
    });
  }
}
