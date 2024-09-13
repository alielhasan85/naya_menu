import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File imageFile, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(imageFile);
      return await ref
          .getDownloadURL(); // Get the download URL to use in Firestore or UI.
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
