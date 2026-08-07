import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

import '../data_sources/firestore/students_remote_data_source.dart';
import '../models/student_model.dart';

class StudentsRepositoryImpl implements StudentsRepository {
  final StudentsRemoteDataSource _remoteDataSource;

  const StudentsRepositoryImpl({
    required StudentsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<AppErrorModel, List<StudentEntity>>> getStudents({
    String? gradeId,
  }) async {
    try {
      final students = await _remoteDataSource.getStudents(
        gradeId: gradeId,
      );

      final entities = List<StudentEntity>.from(students);

      return Right(entities);
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    }
  }

  @override
  Future<Either<AppErrorModel, StudentEntity>> getStudentById({
    required String studentId,
  }) async {
    try {
      final student = await _remoteDataSource.getStudentById(
        studentId: studentId,
      );

      return Right(student);
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    }
  }

  @override
  Stream<Either<AppErrorModel, List<StudentEntity>>> streamStudents({
    String? gradeId,
  }) async* {
    try {
      await for (final students in _remoteDataSource.streamStudents(
        gradeId: gradeId,
      )) {
        final entities = List<StudentEntity>.from(students);

        yield Right(entities);
      }
    } on FirebaseRemoteException catch (error) {
      yield Left(error.errorModel);
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> createStudent({
    required StudentEntity student,
  }) async {
    try {
      final studentModel = StudentModel.fromEntity(student);

      await _remoteDataSource.createStudent(
        student: studentModel,
      );

      return Right(unit);
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> updateStudent({
    required StudentEntity student,
  }) async {
    try {
      final studentModel = StudentModel.fromEntity(student);

      await _remoteDataSource.updateStudent(
        student: studentModel,
      );

      return Right(unit);
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> deleteStudent({
    required String studentId,
  }) async {
    try {
      await _remoteDataSource.deleteStudent(
        studentId: studentId,
      );

      return Right(unit);
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    }
  }
}