import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/features/exams/data/validation/core/validation_handler.dart';
import 'package:alwaleed_admain/features/exams/data/validation/models/exams_validation_data.dart';

class ImageBytesHandler extends ValidationHandler<ImageValidationData> {
  @override
  void validate(ImageValidationData data) {
    if (data.image.bytes.isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class ImageNameHandler extends ValidationHandler<ImageValidationData> {
  @override
  void validate(ImageValidationData data) {
    final String name = data.image.name.trim();
    final int dotIndex = name.lastIndexOf('.');

    if (name.isEmpty || dotIndex < 0 || dotIndex == name.length - 1) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class ImageExtensionHandler extends ValidationHandler<ImageValidationData> {
  static const Set<String> allowedExtensions = <String>{
    'jpg',
    'jpeg',
    'png',
    'webp',
  };

  @override
  void validate(ImageValidationData data) {
    final String name = data.image.name.trim().toLowerCase();
    final int dotIndex = name.lastIndexOf('.');

    if (dotIndex < 0 || dotIndex == name.length - 1) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }

    final String extension = name.substring(dotIndex + 1);

    if (!allowedExtensions.contains(extension)) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}