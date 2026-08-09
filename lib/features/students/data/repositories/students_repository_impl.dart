import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
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

  static const Duration _requestTimeout = Duration(seconds: 10);

  @override
  Future<Either<AppErrorModel, List<StudentEntity>>> getStudents({
    String? gradeId,
  }) {
    return _execute<List<StudentEntity>>(() async {
      final students = await _remoteDataSource.getStudents(gradeId: gradeId);
      return List<StudentEntity>.from(students);
    });
  }

  @override
  Future<Either<AppErrorModel, StudentEntity>> getStudentById({
    required String studentId,
  }) {
    return _execute<StudentEntity>(() async {
      return _remoteDataSource.getStudentById(studentId: studentId);
    });
  }

  @override
  Stream<Either<AppErrorModel, List<StudentEntity>>> streamStudents({
    String? gradeId,
  }) async* {
    try {
      await for (final students in _remoteDataSource.streamStudents(
        gradeId: gradeId,
      )) {
        yield Right<AppErrorModel, List<StudentEntity>>(
          List<StudentEntity>.from(students),
        );
      }
    } catch (error) {
      yield Left<AppErrorModel, List<StudentEntity>>(
        FirebaseErrorHandler.handle(error),
      );
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> createStudent({
    required StudentEntity student,
  }) {
    return _execute<Unit>(() async {
      final studentModel = StudentModel.fromEntity(student);

      await _remoteDataSource.createStudent(student: studentModel);

      return unit;
    });
  }

  @override
  Future<Either<AppErrorModel, Unit>> updateStudent({
    required StudentEntity student,
  }) {
    return _execute<Unit>(() async {
      final studentModel = StudentModel.fromEntity(student);

      await _remoteDataSource.updateStudent(student: studentModel);

      return unit;
    });
  }

  @override
  Future<Either<AppErrorModel, Unit>> deleteStudent({
    required String studentId,
  }) {
    return _execute<Unit>(() async {
      await _remoteDataSource.deleteStudent(studentId: studentId);
      return unit;
    });
  }

  Future<Either<AppErrorModel, T>> _execute<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation().timeout(_requestTimeout);

      return Right<AppErrorModel, T>(result);
    } catch (error) {
      return Left<AppErrorModel, T>(FirebaseErrorHandler.handle(error));
    }
  }
}
