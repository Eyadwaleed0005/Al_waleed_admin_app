import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admain/features/result_student/data/data_source/student_exam_results_remote_data_source.dart';
import 'package:alwaleed_admain/features/result_student/domain/entities/student_exam_results_overview_entity.dart';
import 'package:alwaleed_admain/features/result_student/domain/repository/student_exam_results_repository.dart';
import 'package:dartz/dartz.dart';

class StudentExamResultsRepositoryImpl
    implements StudentExamResultsRepository {
  final StudentExamResultsRemoteDataSource studentExamResultsRemoteDataSource;

  const StudentExamResultsRepositoryImpl({
    required this.studentExamResultsRemoteDataSource,
  });

  @override
  Future<Either<AppErrorModel, StudentExamResultsOverviewEntity>>
      getStudentExamResultsByStudentId({
    required String studentId,
  }) async {
    try {
      final StudentExamResultsOverviewEntity studentExamResults =
          await studentExamResultsRemoteDataSource
              .getStudentExamResultsByStudentId(
                studentId: studentId,
              );

      return Right(studentExamResults);
    } on FirebaseRemoteException catch (exception) {
      return Left(exception.errorModel);
    }
  }
}