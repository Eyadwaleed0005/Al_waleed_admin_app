import 'dart:typed_data';

import 'package:alwaleed_admain/core/helper/app_image_validator.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AppImageCompressionResult {
  const AppImageCompressionResult({
    required this.bytes,
    required this.fileName,
    required this.wasCompressed,
  });

  final Uint8List bytes;
  final String fileName;
  final bool wasCompressed;

  int get sizeInBytes => bytes.lengthInBytes;
}

class AppImageCompressionException implements Exception {
  const AppImageCompressionException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AppImageCompressionHelper {
  AppImageCompressionHelper._();

  static const int targetSizeInKilobytes = 300;

  static const int targetSizeInBytes = targetSizeInKilobytes * 1024;

  static const List<_CompressionAttempt> _compressionAttempts = [
    _CompressionAttempt(maximumDimension: 1600, quality: 82),
    _CompressionAttempt(maximumDimension: 1600, quality: 72),
    _CompressionAttempt(maximumDimension: 1280, quality: 72),
    _CompressionAttempt(maximumDimension: 1280, quality: 62),
    _CompressionAttempt(maximumDimension: 1024, quality: 62),
    _CompressionAttempt(maximumDimension: 1024, quality: 52),
    _CompressionAttempt(maximumDimension: 800, quality: 45),
  ];

  static Future<AppImageCompressionResult> compressForFirebase({
    required Uint8List bytes,
    required String originalFileName,
  }) async {
    if (bytes.isEmpty) {
      throw const AppImageCompressionException('الصورة المحددة فارغة');
    }

    if (bytes.lengthInBytes <= targetSizeInBytes) {
      return AppImageCompressionResult(
        bytes: bytes,
        fileName: _normalizeOriginalFileName(originalFileName),
        wasCompressed: false,
      );
    }

    Uint8List smallestBytes = bytes;

    for (final attempt in _compressionAttempts) {
      final compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: attempt.maximumDimension,
        minHeight: attempt.maximumDimension,
        quality: attempt.quality,
        format: CompressFormat.jpeg,
        keepExif: false,
        autoCorrectionAngle: true,
      );

      if (compressedBytes.isEmpty) {
        continue;
      }

      if (compressedBytes.lengthInBytes < smallestBytes.lengthInBytes) {
        smallestBytes = compressedBytes;
      }

      if (smallestBytes.lengthInBytes <= targetSizeInBytes) {
        break;
      }
    }

    if (smallestBytes.lengthInBytes >
        AppImageValidator.maximumCompressedImageSizeInBytes) {
      throw const AppImageCompressionException(
        'تعذر ضغط الصورة إلى الحجم المناسب، اختر صورة أخرى',
      );
    }

    return AppImageCompressionResult(
      bytes: smallestBytes,
      fileName: _buildCompressedFileName(originalFileName),
      wasCompressed: true,
    );
  }

  static String _normalizeOriginalFileName(String originalFileName) {
    final normalizedName = originalFileName.trim();

    if (normalizedName.isEmpty) {
      return 'question_image';
    }

    return normalizedName;
  }

  static String _buildCompressedFileName(String originalFileName) {
    final normalizedName = originalFileName.trim();

    if (normalizedName.isEmpty) {
      return 'question_image.jpg';
    }

    final lastDotIndex = normalizedName.lastIndexOf('.');

    final nameWithoutExtension = lastDotIndex > 0
        ? normalizedName.substring(0, lastDotIndex)
        : normalizedName;

    return '${nameWithoutExtension}_compressed.jpg';
  }
}

class _CompressionAttempt {
  const _CompressionAttempt({
    required this.maximumDimension,
    required this.quality,
  });

  final int maximumDimension;
  final int quality;
}
