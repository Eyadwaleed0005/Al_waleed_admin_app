import 'package:alwaleed_admin/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admin/features/exams/data/validation/core/validation_handler.dart';
import 'package:alwaleed_admin/features/exams/data/validation/models/exams_validation_data.dart';

class IdNotEmptyHandler extends ValidationHandler<IdValidationData> {
  @override
  void validate(IdValidationData data) {
    if (data.value.trim().isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class IdPathSeparatorHandler extends ValidationHandler<IdValidationData> {
  @override
  void validate(IdValidationData data) {
    if (data.value.trim().contains('/')) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}
