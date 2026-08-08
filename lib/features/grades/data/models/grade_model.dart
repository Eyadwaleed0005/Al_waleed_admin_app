import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';

class GradeModel extends GradeEntity {
  const GradeModel({
    required super.gradeId,
    required super.name,
    required super.displayOrder,
    required super.isActive,
  });

  factory GradeModel.fromMap({
    required String documentId,
    required Map<String, dynamic> map,
  }) {
    final name = map[FirestoreFields.name];

    if (name is! String || name.trim().isEmpty) {
      throw const FormatException(
        'Grade name is missing or invalid.',
      );
    }

    return GradeModel(
      gradeId:
          map[FirestoreFields.gradeId] as String? ??
          documentId,
      name: name.trim(),
      displayOrder:
          (map[FirestoreFields.displayOrder] as num?)
                  ?.toInt() ??
              0,
      isActive:
          map[FirestoreFields.isActive] as bool? ??
          true,
    );
  }
}