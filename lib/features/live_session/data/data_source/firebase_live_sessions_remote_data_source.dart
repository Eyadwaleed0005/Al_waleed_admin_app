import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';

import '../models/live_session_model.dart';
import 'live_sessions_remote_data_source.dart';

class FirebaseLiveSessionsRemoteDataSource
    implements LiveSessionsRemoteDataSource {
  const FirebaseLiveSessionsRemoteDataSource({
    required FirestoreService firestoreService,
  }) : _firestoreService = firestoreService;

  final FirestoreService _firestoreService;

  @override
  Future<LiveSessionModel?> getLiveSession({required String gradeId}) {
    return _execute(() async {
      final document = await _firestoreService.getDocument(
        collectionPath: FirestoreCollections.liveSessions,
        documentId: gradeId,
      );

      final data = document.data();

      if (!document.exists || data == null) {
        return null;
      }

      return LiveSessionModel.fromMap({
        ...data,
        FirestoreFields.gradeId: document.id,
      });
    });
  }

  @override
  Future<void> saveLiveSession({required LiveSessionModel liveSession}) {
    return _execute(() async {
      await _firestoreService.postData(
        collectionPath: FirestoreCollections.liveSessions,
        documentId: liveSession.gradeId,
        data: liveSession.toMap(),
      );
    });
  }

  @override
  Future<void> deleteLiveSession({required String gradeId}) {
    return _execute(() async {
      await _firestoreService.deleteData(
        collectionPath: FirestoreCollections.liveSessions,
        documentId: gradeId,
      );
    });
  }

  Future<T> _execute<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on FirebaseRemoteException {
      rethrow;
    } catch (error) {
      throw FirebaseRemoteException(
        errorModel: FirebaseErrorHandler.handle(error),
      );
    }
  }
}
