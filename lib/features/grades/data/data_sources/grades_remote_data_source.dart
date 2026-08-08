import 'package:alwaleed_admain/features/grades/data/models/grade_model.dart';

abstract interface class GradesRemoteDataSource {
  Future<List<GradeModel>> getGrades({
    bool activeOnly = true,
  });

  Stream<List<GradeModel>> streamGrades({
    bool activeOnly = true,
  });
}