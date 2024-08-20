import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naya_menu/models/venue/venue_index.dart';

class FirestoreVenueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new venue
  Future<void> addVenue(Venue venue) async {
    await _firestore.collection('restaurants').doc(venue.id).set(venue.toMap());
  }

  // Set venue information for the venue
  Future<void> setVenueInfo(String venueId, VenueInfo venueInfo) async {
    await _firestore
        .collection('restaurants')
        .doc(venueId)
        .collection('venueInfo')
        .doc('main')
        .set(venueInfo.toMap());
  }

  // Set contact information for the venue
  Future<void> setContactInfo(String venueId, ContactInfo contactInfo) async {
    await _firestore
        .collection('restaurants')
        .doc(venueId)
        .collection('contactInfo')
        .doc('main')
        .set(contactInfo.toMap());
  }

  // Set language options for the venue
  Future<void> setLanguageOptions(
      String venueId, LanguageOptions languageOptions) async {
    await _firestore
        .collection('restaurants')
        .doc(venueId)
        .collection('languageOptions')
        .doc('main')
        .set(languageOptions.toMap());
  }

  // Set social accounts for the venue
  Future<void> setSocialAccounts(
      String venueId, SocialAccounts socialAccounts) async {
    await _firestore
        .collection('restaurants')
        .doc(venueId)
        .collection('socialAccounts')
        .doc('main')
        .set(socialAccounts.toMap());
  }

  // Set operations for the venue
  Future<void> setOperations(String venueId, Operations operations) async {
    await _firestore
        .collection('restaurants')
        .doc(venueId)
        .collection('operations')
        .doc('main')
        .set(operations.toMap());
  }

  // Set QR codes for the venue
  Future<void> setQRCodes(String venueId, QRCodes qrCodes) async {
    await _firestore
        .collection('restaurants')
        .doc(venueId)
        .collection('qrCodes')
        .doc('main')
        .set(qrCodes.toMap());
  }

  // Set theme data for the venue
  Future<void> setThemeData(String venueId, ThemeData themeData) async {
    await _firestore
        .collection('restaurants')
        .doc(venueId)
        .collection('themeData')
        .doc('main')
        .set(themeData.toMap());
  }

  // Set timing hours for the venue
  Future<void> setTimingHours(String venueId, TimingHours timingHours) async {
    await _firestore
        .collection('restaurants')
        .doc(venueId)
        .collection('timingHours')
        .doc('main')
        .set(timingHours.toMap());
  }

  // Set price options for the venue
  Future<void> setPriceOptions(
      String venueId, PriceOptions priceOptions) async {
    await _firestore
        .collection('restaurants')
        .doc(venueId)
        .collection('priceOptions')
        .doc('main')
        .set(priceOptions.toMap());
  }

  // Set subscription status for the venue
  Future<void> setSubscriptionStatus(
      String venueId, SubscriptionStatus subscriptionStatus) async {
    await _firestore
        .collection('restaurants')
        .doc(venueId)
        .collection('subscriptionStatus')
        .doc('main')
        .set(subscriptionStatus.toMap());
  }

  // Example: Get venue information by venue ID
  Future<VenueInfo?> getVenueInfo(String venueId) async {
    DocumentSnapshot doc = await _firestore
        .collection('restaurants')
        .doc(venueId)
        .collection('venueInfo')
        .doc('main')
        .get();
    if (doc.exists) {
      return VenueInfo.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Additional methods for other subcollections can be added similarly...
}
