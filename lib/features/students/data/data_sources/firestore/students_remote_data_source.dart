import '../../models/student_model.dart';

abstract interface class StudentsRemoteDataSource {
  Future<List<StudentModel>> getStudents({
    String? gradeId,
  });

  Future<StudentModel> getStudentById({
    required String studentId,
  });

  Stream<List<StudentModel>> streamStudents({
    String? gradeId,
  });

  Future<void> createStudent({
    required StudentModel student,
  });

  Future<void> updateStudent({
    required StudentModel student,
  });

  Future<void> deleteStudent({
    required String studentId,
  });
}