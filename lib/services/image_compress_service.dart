/// Image Compress Service - PRD 05 Precision Spec
/// Max upload 5 MB. Client-side compression to 1080p WebP before storage.
/// No AI background removal.

class ImageCompressService {
  static const maxSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const targetWidth = 1080;

  /// Validates file size before upload (PRD gate)
  static bool isValidSize(int bytes) => bytes <= maxSizeBytes;

  /// Placeholder for compression logic (Phase C will use flutter_image_compress)
  /// Returns true if compression would be applied
  static bool needsCompression(int bytes, int width) =>
      bytes > maxSizeBytes || width > targetWidth;

  static String getCompressionNote(int bytes) {
    if (bytes > maxSizeBytes) return '5 MB → 1080p WebP compression will be applied';
    return 'Ready for upload • WebP 1080p';
  }
}
