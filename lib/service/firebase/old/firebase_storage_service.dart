import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Function to upload an image from File and return the download URL
  Future<String> uploadImage(
      File image, String restaurantName, String title, String type) async {
    try {
      final storageRef =
          _storage.ref().child('$restaurantName/$type/$title.webp');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  // Function to upload an image from bytes and return the download URL
  Future<String> uploadImageBytes(Uint8List imageBytes, String restaurantName,
      String title, String type) async {
    try {
      final storageRef =
          _storage.ref().child('$restaurantName/$type/$title.webp');
      final uploadTask = storageRef.putData(imageBytes);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  // Function to delete an image by URL
  Future<void> deleteImage(String imageUrl) async {
    try {
      final storageRef = _storage.refFromURL(imageUrl);
      await storageRef.delete();
    } catch (e) {
      throw Exception('Error deleting image: $e');
    }
  }

  // Function to upload logo image
  Future<String> uploadLogo(
      File image, String restaurantName, String title) async {
    return await uploadImage(image, restaurantName, title, 'logos');
  }

  // Function to upload background image
  Future<String> uploadBackgroundImage(
      File image, String restaurantName, String title) async {
    return await uploadImage(image, restaurantName, title, 'backgrounds');
  }

  // Function to upload logo image from bytes
  Future<String> uploadLogoBytes(
      Uint8List imageBytes, String restaurantName, String title) async {
    return await uploadImageBytes(imageBytes, restaurantName, title, 'logos');
  }

  // Function to upload background image from bytes
  Future<String> uploadBackgroundImageBytes(
      Uint8List imageBytes, String restaurantName, String title) async {
    return await uploadImageBytes(
        imageBytes, restaurantName, title, 'backgrounds');
  }

  // Function to delete all files of a restaurant
  Future<void> deleteRestaurantFiles(String restaurantName) async {
    try {
      final ListResult result =
          await _storage.ref().child(restaurantName).listAll();
      for (var file in result.items) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Error deleting restaurant files: $e');
    }
  }
}
