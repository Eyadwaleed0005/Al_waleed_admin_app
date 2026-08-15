import 'dart:typed_data';

class AppImageValidator {
  AppImageValidator._();

  static const int maximumPickedImageSizeInMegabytes = 5;

  static const int maximumPickedImageSizeInBytes =
      maximumPickedImageSizeInMegabytes * 1024 * 1024;

  static const int maximumCompressedImageSizeInKilobytes = 500;

  static const int maximumCompressedImageSizeInBytes =
      maximumCompressedImageSizeInKilobytes * 1024;

  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

  static String? validatePickedImage({
    required String fileName,
    required String? extension,
    required int sizeInBytes,
    required Uint8List? bytes,
  }) {
    final normalizedName = fileName.trim().toLowerCase();

    final normalizedExtension =
        extension?.trim().toLowerCase() ?? _extractExtension(normalizedName);

    if (!allowedExtensions.contains(normalizedExtension)) {
      return 'يجب اختيار صورة بصيغة JPG أو PNG أو WEBP';
    }

    if (sizeInBytes <= 0) {
      return 'الصورة المحددة فارغة';
    }

    if (sizeInBytes > maximumPickedImageSizeInBytes) {
      return 'حجم الصورة أكبر من الحد الأقصى '
          '${maximumPickedImageSizeInMegabytes}MB';
    }

    if (bytes == null || bytes.isEmpty) {
      return 'تعذر قراءة الصورة المحددة';
    }

    if (!_isSupportedImageContent(bytes)) {
      return 'الملف المحدد ليس صورة صالحة';
    }

    if (!_extensionMatchesImageContent(
      extension: normalizedExtension,
      bytes: bytes,
    )) {
      return 'امتداد الصورة لا يتوافق مع محتواها';
    }

    return null;
  }

  static String? validateCompressedImage(Uint8List bytes) {
    if (bytes.isEmpty) {
      return 'تعذر ضغط الصورة المحددة';
    }

    if (!_isSupportedImageContent(bytes)) {
      return 'نتيجة ضغط الصورة غير صالحة';
    }

    if (bytes.lengthInBytes > maximumCompressedImageSizeInBytes) {
      return 'تعذر تقليل حجم الصورة إلى أقل من '
          '${maximumCompressedImageSizeInKilobytes}KB';
    }

    return null;
  }

  static String _extractExtension(String fileName) {
    final lastDotIndex = fileName.lastIndexOf('.');

    if (lastDotIndex == -1 || lastDotIndex == fileName.length - 1) {
      return '';
    }

    return fileName.substring(lastDotIndex + 1);
  }

  static bool _extensionMatchesImageContent({
    required String extension,
    required Uint8List bytes,
  }) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return _isJpeg(bytes);

      case 'png':
        return _isPng(bytes);

      case 'webp':
        return _isWebp(bytes);

      default:
        return false;
    }
  }

  static bool _isSupportedImageContent(Uint8List bytes) {
    return _isJpeg(bytes) || _isPng(bytes) || _isWebp(bytes);
  }

  static bool _isJpeg(Uint8List bytes) {
    if (bytes.lengthInBytes < 3) {
      return false;
    }

    return bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF;
  }

  static bool _isPng(Uint8List bytes) {
    if (bytes.lengthInBytes < 8) {
      return false;
    }

    return bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A;
  }

  static bool _isWebp(Uint8List bytes) {
    if (bytes.lengthInBytes < 12) {
      return false;
    }

    final hasRiffHeader =
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46;

    final hasWebpHeader =
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50;

    return hasRiffHeader && hasWebpHeader;
  }
}
