import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image and return the download URL
  Future<String?> uploadImage({
    required Uint8List imageData,
    required String userId,
    required String venueId,
    required String imageType, // Type of image: logo, background, meal, etc.
  }) async {
    try {
      // Create a storage reference with a logical naming convention
      String fileName = _generateFileName(userId, venueId, imageType);
      Reference ref = _storage.ref().child(fileName);

      // Upload the image
      UploadTask uploadTask = ref.putData(imageData);

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Generate a unique and logical file name
  String _generateFileName(String userId, String venueId, String imageType) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'users/$userId/venues/$venueId/images/$imageType-$timestamp.jpg';
  }

  // Delete image from Firebase Storage by URL
  Future<void> deleteImage(String imageUrl) async {
    try {
      final storageRef = _storage.refFromURL(imageUrl);
      await storageRef.delete();
      print("Image deleted successfully");
    } catch (e) {
      print("Error deleting image: $e");
      throw Exception('Error deleting image: $e');
    }
  }

  // Delete all images for a specific venue
  Future<void> deleteAllVenueImages(String userId, String venueId) async {
    try {
      final ListResult result = await _storage
          .ref()
          .child('users/$userId/venues/$venueId/images')
          .listAll();

      for (var file in result.items) {
        await file.delete();
      }
      print("All venue images deleted successfully");
    } catch (e) {
      print("Error deleting all venue images: $e");
      throw Exception('Error deleting all venue images: $e');
    }
  }

  // Delete all files related to a specific user
  Future<void> deleteAllUserFiles(String userId) async {
    try {
      final ListResult result =
          await _storage.ref().child('users/$userId').listAll();
      for (var file in result.items) {
        await file.delete();
      }
      print("All user files deleted successfully");
    } catch (e) {
      print("Error deleting all user files: $e");
      throw Exception('Error deleting all user files: $e');
    }
  }
}
