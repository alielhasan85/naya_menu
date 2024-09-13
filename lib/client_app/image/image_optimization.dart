import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageOptimizerService {
  // Optimization for mobile using File
  Future<File?> optimizeFile(File imageFile,
      {required int targetSizeKB, String format = 'jpg'}) async {
    final originalImage = img.decodeImage(imageFile.readAsBytesSync());
    if (originalImage != null) {
      // Set initial quality for compression
      int quality = 100;
      File? optimizedFile;

      // Continue compressing until the file size is within the target size
      do {
        quality -= 10;

        // Check format and encode accordingly
        List<int>? optimizedBytes;
        if (format == 'jpg') {
          optimizedBytes = img.encodeJpg(originalImage, quality: quality);
        } else {
          optimizedBytes =
              img.encodePng(originalImage); // PNG doesn't use quality
        }

        // Write the optimized bytes to a new file
        optimizedFile =
            File(imageFile.path.replaceFirst('.jpg', '.optimized.jpg'))
              ..writeAsBytesSync(optimizedBytes);
      } while (
          optimizedFile.lengthSync() / 1024 > targetSizeKB && quality > 10);

      return optimizedFile;
    }
    return null;
  }

  // Optimization for web using Uint8List
  Future<Uint8List?> optimizeWebImage(Uint8List imageBytes,
      {required int targetSizeKB, String format = 'jpg'}) async {
    final originalImage = img.decodeImage(imageBytes);
    if (originalImage != null) {
      int quality = 100;
      Uint8List? optimizedBytes;

      // Continue compressing until the file size is within the target size
      do {
        quality -= 10;

        // Check format and encode accordingly
        if (format == 'jpg') {
          optimizedBytes = Uint8List.fromList(
              img.encodeJpg(originalImage, quality: quality));
        } else {
          optimizedBytes = Uint8List.fromList(
              img.encodePng(originalImage)); // PNG doesn't use quality
        }
      } while (optimizedBytes.length / 1024 > targetSizeKB && quality > 10);

      return optimizedBytes;
    }
    return null;
  }
}
