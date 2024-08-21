import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naya_menu/models/client/users.dart';

class FirestoreUser {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection;

  FirestoreUser()
      : _usersCollection = FirebaseFirestore.instance.collection('users');

  // Check if a user with the given email or phone number already exists in Firestore.
  Future<bool> checkIfUserExists(
      {required String email, String? phoneNumber}) async {
    // Check by email
    final querySnapshot =
        await _usersCollection.where('email', isEqualTo: email).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      return true;
    }

    // Optionally check by phone number if provided
    if (phoneNumber != null) {
      final phoneQuerySnapshot = await _usersCollection
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      return phoneQuerySnapshot.docs.isNotEmpty;
    }

    return false;
  }

  // Add a new user to Firestore with the provided [UserModel] data.
  Future<void> addUser(UserModel user) async {
    await _usersCollection.doc(user.id).set(user.toMap());
  }

  // Delete a user from Firestore by their [userId].
  Future<void> deleteUser(String userId) async {
    await _usersCollection.doc(userId).delete();
  }

  // Deactivate a user by setting their `isActive` field to false (soft delete).
  Future<void> deactivateUser(String userId) async {
    await _usersCollection.doc(userId).update({'isActive': false});
  }

  // Reactivate a user by setting their `isActive` field to true.
  Future<void> reactivateUser(String userId) async {
    await _usersCollection.doc(userId).update({'isActive': true});
  }

  // Update specific fields of a user's data by their [userId] with the [updatedData] provided.
  Future<void> updateUser(
      String userId, Map<String, dynamic> updatedData) async {
    await _usersCollection.doc(userId).update(updatedData);
  }

  // Retrieve a user's data from Firestore by their [userId].
  Future<UserModel?> getUserById(String userId) async {
    final docSnapshot = await _usersCollection.doc(userId).get();

    if (docSnapshot.exists) {
      return UserModel.fromMap(
          docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
    }

    return null;
  }

  /// Retrieve a list of all users in Firestore (useful for an admin dashboard).
  Future<List<UserModel>> getAllUsers() async {
    final querySnapshot = await _usersCollection.get();
    return querySnapshot.docs
        .map((doc) =>
            UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Search for users by their first name or email using the [query] provided.
  Future<List<UserModel>> searchUsers(String query) async {
    final querySnapshot = await _usersCollection
        .where('firstName', isGreaterThanOrEqualTo: query)
        .where('firstName', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    return querySnapshot.docs
        .map((doc) =>
            UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  /// Log user activity by appending the [activity] to the user's `recentActivities` field.
  Future<void> logUserActivity(String userId, String activity) async {
    await _usersCollection.doc(userId).update({
      'lastActivity': DateTime.now(),
      'recentActivities': FieldValue.arrayUnion([activity]),
    });
  }

  /// Set the role of a user by their [userId] with the [role] provided.
  Future<void> setUserRole(String userId, String role) async {
    await _usersCollection.doc(userId).update({'role': role});
  }

  /// Retrieve the role of a user by their [userId].
  Future<String?> getUserRole(String userId) async {
    final docSnapshot = await _usersCollection.doc(userId).get();
    if (docSnapshot.exists) {
      return docSnapshot.get('role') as String?;
    }
    return null;
  }

  /// Set a password reset token for a user by their [userId] with the [token] provided.
  Future<void> setPasswordResetToken(String userId, String token) async {
    await _usersCollection
        .doc(userId)
        .update({'resetToken': token, 'tokenGeneratedAt': DateTime.now()});
  }

  /// Update the subscription type of a user by their [userId] with the [subscriptionType] provided.
  Future<void> updateUserSubscription(
      String userId, String subscriptionType) async {
    await _usersCollection
        .doc(userId)
        .update({'subscription': subscriptionType});
  }

  /// Update the notification preferences of a user by their [userId] with the options for [emailNotification] and [smsNotification].
  Future<void> updateUserNotificationPreferences(String userId,
      {bool? emailNotification, bool? smsNotification}) async {
    final updates = <String, dynamic>{};
    if (emailNotification != null)
      updates['emailNotification'] = emailNotification;
    if (smsNotification != null) updates['smsNotification'] = smsNotification;

    await _usersCollection.doc(userId).update(updates);
  }
}
