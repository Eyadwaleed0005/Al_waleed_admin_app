import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admain/features/grades/data/models/grade_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'grades_remote_data_source.dart';

class FirebaseGradesRemoteDataSource
    implements GradesRemoteDataSource {
  final FirestoreService _firestoreService;

  const FirebaseGradesRemoteDataSource({
    required FirestoreService firestoreService,
  }) : _firestoreService = firestoreService;

  @override
  Future<List<GradeModel>> getGrades({
    bool activeOnly = true,
  }) {
    return _execute(() async {
      final snapshot =
          await _firestoreService.getCollection(
        collectionPath:
            FirestoreCollections.grades,
        queryBuilder:
            _getGradesQuery(activeOnly),
      );

      return _mapGrades(snapshot);
    });
  }

  @override
  Stream<List<GradeModel>> streamGrades({
    bool activeOnly = true,
  }) {
    return _executeStream(() {
      return _firestoreService
          .streamCollection(
            collectionPath:
                FirestoreCollections.grades,
            queryBuilder:
                _getGradesQuery(activeOnly),
          )
          .map(_mapGrades);
    });
  }

  FirestoreQueryBuilder _getGradesQuery(
    bool activeOnly,
  ) {
    return (collection) {
      Query<Map<String, dynamic>> query =
          collection;

      if (activeOnly) {
        query = query.where(
          FirestoreFields.isActive,
          isEqualTo: true,
        );
      }

      return query.orderBy(
        FirestoreFields.displayOrder,
      );
    };
  }

  List<GradeModel> _mapGrades(
    QuerySnapshot<Map<String, dynamic>>
        snapshot,
  ) {
    return snapshot.docs.map((document) {
      return GradeModel.fromMap(
        documentId: document.id,
        map: document.data(),
      );
    }).toList();
  }

  Future<T> _execute<T>(
    Future<T> Function() operation,
  ) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      if (error is FirebaseRemoteException) {
        Error.throwWithStackTrace(
          error,
          stackTrace,
        );
      }

      final remoteException =
          FirebaseRemoteException(
        errorModel:
            FirebaseErrorHandler.handle(error),
      );

      Error.throwWithStackTrace(
        remoteException,
        stackTrace,
      );
    }
  }

  Stream<T> _executeStream<T>(
    Stream<T> Function() operation,
  ) async* {
    try {
      yield* operation();
    } catch (error, stackTrace) {
      if (error is FirebaseRemoteException) {
        Error.throwWithStackTrace(
          error,
          stackTrace,
        );
      }

      final remoteException =
          FirebaseRemoteException(
        errorModel:
            FirebaseErrorHandler.handle(error),
      );

      Error.throwWithStackTrace(
        remoteException,
        stackTrace,
      );
    }
  }
}