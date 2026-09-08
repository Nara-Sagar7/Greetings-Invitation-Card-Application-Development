import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Image Compress Service - PRD 05 Precision Spec
/// Max upload 5 MB. Client-side compression to 1080p WebP before storage.
class ImageCompressService {
  static const maxSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const targetWidth = 1080;

  /// Validates file size before upload (PRD gate)
  static bool isValidSize(int bytes) => bytes <= maxSizeBytes;

  static bool needsCompression(int bytes, int width) =>
      bytes > maxSizeBytes || width > targetWidth;

  static String getCompressionNote(int bytes) {
    if (bytes > maxSizeBytes) {
      return '5 MB → 1080p WebP compression will be applied';
    }
    return 'Ready for upload • WebP 1080p';
  }

  /// Compress file to WebP 1080p P1-5
  static Future<Uint8List?> compressFile(File file, {int quality = 85}) async {
    final bytes = await file.length();
    if (!needsCompression(bytes, targetWidth + 1)) {
      return file.readAsBytes();
    }
    return FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: targetWidth,
      quality: quality,
      format: CompressFormat.webp,
    );
  }

  /// Compress XFile bytes
  static Future<Uint8List?> compressXFile(
    String path, {
    int quality = 85,
  }) async {
    final file = File(path);
    return compressFile(file, quality: quality);
  }
}
