import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageUploadPopup extends StatefulWidget {
  final Function(String?) onImageUploaded;

  const ImageUploadPopup({super.key, required this.onImageUploaded});

  @override
  _ImageUploadPopupState createState() => _ImageUploadPopupState();
}

class _ImageUploadPopupState extends State<ImageUploadPopup> {
  Uint8List? _imageBytes;
  String? _optimizedImageUrl;

  Future<void> _pickImage(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        setState(() {
          _imageBytes = result.files.first.bytes;
          _uploadToImageKit(); // Upload to ImageKit.io for processing
        });
      } else {
        _showAlertDialog(
            'No Image Selected', 'Please select an image to continue.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadToImageKit() async {
    if (_imageBytes == null) return;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://upload.imagekit.io/api/v1/files/upload'),
      );

      request.fields['fileName'] = 'temp_image.jpg';
      request.fields['publicKey'] =
          'public_9WVQt+IXYE56ZXJ/LKMhOW7OFdc='; // Your public key
      request.files.add(http.MultipartFile.fromBytes('file', _imageBytes!));

      var headers = {
        'Authorization': 'Basic ' +
            base64Encode(
                utf8.encode('private_tATjeTWWpq3GL13s9l9OkggCTnw=' + ':')),
      };

      request.headers.addAll(headers);

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        String imageUrl = _parseImageUrl(responseData);
        setState(() {
          _optimizedImageUrl = _applyImageTransformations(imageUrl);
        });
      } else {
        print('Failed to upload image to ImageKit.io: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  String _parseImageUrl(String responseData) {
    // Assuming the response contains a JSON object with a 'url' field
    var jsonResponse = json.decode(responseData);
    return jsonResponse['url'];
  }

  String _applyImageTransformations(String imageUrl) {
    // Example transformation: Resize to 300x300 and apply blur
    return "$imageUrl?tr=w-300,h-300,bl-10";
  }

  Future<void> _downloadAndUploadToFirebase() async {
    if (_optimizedImageUrl == null) return;

    try {
      var response = await http.get(Uri.parse(_optimizedImageUrl!));
      Uint8List optimizedImageBytes = response.bodyBytes;

      String firebasePath = 'images/optimized_image.jpg';
      var firebaseStorageRef =
          FirebaseStorage.instance.ref().child(firebasePath);
      await firebaseStorageRef.putData(optimizedImageBytes);

      String downloadUrl = await firebaseStorageRef.getDownloadURL();

      widget.onImageUploaded(downloadUrl);
    } catch (e) {
      print('Error uploading to Firebase: $e');
    }
  }

  void _applyImage() {
    _downloadAndUploadToFirebase();
    Navigator.of(context).pop(); // Close the dialog
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Edit Image",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: _applyImage,
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _pickImage(context),
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.black12),
                ),
                child: _optimizedImageUrl != null
                    ? Image.network(_optimizedImageUrl!, fit: BoxFit.contain)
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload, size: 50, color: Colors.black54),
                            SizedBox(height: 8.0),
                            Text(
                              'Tap to select image',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
