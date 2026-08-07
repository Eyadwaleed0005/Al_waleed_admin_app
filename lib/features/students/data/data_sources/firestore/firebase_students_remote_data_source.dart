import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/student_model.dart';
import 'students_remote_data_source.dart';

class FirebaseStudentsRemoteDataSource implements StudentsRemoteDataSource {
  final FirestoreService _firestoreService;

  const FirebaseStudentsRemoteDataSource({
    required FirestoreService firestoreService,
  }) : _firestoreService = firestoreService;

  @override
  Future<List<StudentModel>> getStudents({String? gradeId}) {
    return _execute(() async {
      final snapshot = await _firestoreService.getCollection(
        collectionPath: FirestoreCollections.students,
        queryBuilder: _getGradeQuery(gradeId),
      );

      return _mapStudents(snapshot);
    });
  }

  @override
  Future<StudentModel> getStudentById({required String studentId}) {
    return _execute(() async {
      final snapshot = await _firestoreService.getDocument(
        collectionPath: FirestoreCollections.students,
        documentId: studentId,
      );

      final data = snapshot.data();

      if (!snapshot.exists || data == null) {
        throw FirebaseRemoteException(
          errorModel: FirebaseErrorHandler.handleFirestoreCode('not-found'),
        );
      }

      return StudentModel.fromMap(documentId: snapshot.id, map: data);
    });
  }

  @override
  Stream<List<StudentModel>> streamStudents({String? gradeId}) {
    return _executeStream(() {
      return _firestoreService
          .streamCollection(
            collectionPath: FirestoreCollections.students,
            queryBuilder: _getGradeQuery(gradeId),
          )
          .map(_mapStudents);
    });
  }

  @override
  Future<void> createStudent({required StudentModel student}) {
    return _execute(() async {
      await _firestoreService.postData(
        collectionPath: FirestoreCollections.students,
        documentId: student.studentId,
        data: student.toCreateMap(),
      );
    });
  }

  @override
  Future<void> updateStudent({required StudentModel student}) {
    return _execute(() async {
      await _firestoreService.patchData(
        collectionPath: FirestoreCollections.students,
        documentId: student.studentId,
        data: student.toUpdateMap(),
      );
    });
  }

  @override
  Future<void> deleteStudent({required String studentId}) {
    return _execute(() async {
      await _firestoreService.deleteData(
        collectionPath: FirestoreCollections.students,
        documentId: studentId,
      );
    });
  }

  FirestoreQueryBuilder? _getGradeQuery(String? gradeId) {
    final normalizedGradeId = gradeId?.trim();

    if (normalizedGradeId == null || normalizedGradeId.isEmpty) {
      return null;
    }

    return (collection) {
      return collection.where(
        FirestoreFields.gradeId,
        isEqualTo: normalizedGradeId,
      );
    };
  }

  List<StudentModel> _mapStudents(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final students = snapshot.docs.map((document) {
      return StudentModel.fromMap(
        documentId: document.id,
        map: document.data(),
      );
    }).toList();

    students.sort((firstStudent, secondStudent) {
      return firstStudent.name.compareTo(secondStudent.name);
    });

    return students;
  }

  Future<T> _execute<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      if (error is FirebaseRemoteException) {
        Error.throwWithStackTrace(error, stackTrace);
      }

      final remoteException = FirebaseRemoteException(
        errorModel: FirebaseErrorHandler.handle(error),
      );

      Error.throwWithStackTrace(remoteException, stackTrace);
    }
  }

  Stream<T> _executeStream<T>(Stream<T> Function() operation) async* {
    try {
      yield* operation();
    } catch (error, stackTrace) {
      if (error is FirebaseRemoteException) {
        Error.throwWithStackTrace(error, stackTrace);
      }

      final remoteException = FirebaseRemoteException(
        errorModel: FirebaseErrorHandler.handle(error),
      );

      Error.throwWithStackTrace(remoteException, stackTrace);
    }
  }
}
