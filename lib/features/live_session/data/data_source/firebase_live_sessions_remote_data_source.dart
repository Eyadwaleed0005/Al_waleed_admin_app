import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/live_session_model.dart';
import 'live_sessions_remote_data_source.dart';

class FirebaseLiveSessionsRemoteDataSource
    implements LiveSessionsRemoteDataSource {
  final FirestoreService _firestoreService;

  const FirebaseLiveSessionsRemoteDataSource({
    required FirestoreService firestoreService,
  }) : _firestoreService = firestoreService;

  @override
  Future<LiveSessionModel?> getLiveSession() {
    return _execute(() async {
      final snapshot = await _firestoreService
          .streamCollection(
            collectionPath: FirestoreCollections.liveSessions,
            queryBuilder: (collection) {
              return collection.limit(1);
            },
            includeMetadataChanges: true,
          )
          .firstWhere((snapshot) {
            final hasCachedLiveSession = snapshot.docs.isNotEmpty;

            final hasServerResponse = !snapshot.metadata.isFromCache;

            return hasCachedLiveSession || hasServerResponse;
          });

      return _mapLiveSession(snapshot);
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

  LiveSessionModel? _mapLiveSession(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    if (snapshot.docs.isEmpty) {
      return null;
    }

    final document = snapshot.docs.first;

    return LiveSessionModel.fromMap({
      ...document.data(),
      FirestoreFields.gradeId: document.id,
    });
  }

  Future<T> _execute<T>(Future<T> Function() operation) {
    return FirebaseErrorHandler.execute(operation);
  }
}
