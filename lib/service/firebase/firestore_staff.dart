import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/client/team.dart';

class FirestoreStaffService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a reference to the staff subcollection of a venue
  CollectionReference _getStaffCollection(String userId, String venueId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId)
        .collection('staff');
  }

  // Add a new staff member to a venue
  Future<void> addStaff(String userId, String venueId, StaffModel staff) async {
    final staffCollection = _getStaffCollection(userId, venueId);
    final staffDoc = staffCollection.doc();
    staff.id = staffDoc.id; // Set the staff ID to the generated document ID
    await staffDoc.set(staff.toMap());
  }

  // Update a staff member's details
  Future<void> updateStaff(
      String userId, String venueId, StaffModel staff) async {
    final staffCollection = _getStaffCollection(userId, venueId);
    await staffCollection.doc(staff.id).update(staff.toMap());
  }

  // Delete a staff member from a venue
  Future<void> deleteStaff(
      String userId, String venueId, String staffId) async {
    final staffCollection = _getStaffCollection(userId, venueId);
    await staffCollection.doc(staffId).delete();
  }

  // Retrieve a specific staff member by ID
  Future<StaffModel?> getStaffById(
      String userId, String venueId, String staffId) async {
    final staffCollection = _getStaffCollection(userId, venueId);
    final docSnapshot = await staffCollection.doc(staffId).get();

    if (docSnapshot.exists) {
      return StaffModel.fromMap(
          docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
    }
    return null;
  }

  // Retrieve all staff members for a venue
  Future<List<StaffModel>> getAllStaff(String userId, String venueId) async {
    final staffCollection = _getStaffCollection(userId, venueId);
    final querySnapshot = await staffCollection.get();

    return querySnapshot.docs.map((doc) {
      return StaffModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Retrieve staff members with specific permissions
  Future<List<StaffModel>> getStaffByPermission(
      String userId, String venueId, String permission) async {
    final staffCollection = _getStaffCollection(userId, venueId);
    final querySnapshot = await staffCollection
        .where('permissions', arrayContains: permission)
        .get();

    return querySnapshot.docs.map((doc) {
      return StaffModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
