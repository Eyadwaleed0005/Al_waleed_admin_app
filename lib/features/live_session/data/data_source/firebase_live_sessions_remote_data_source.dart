import 'package:alwaleed_admain/core/connection/network/network_info.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/live_session_model.dart';
import 'live_sessions_remote_data_source.dart';

class FirebaseLiveSessionsRemoteDataSource
    implements LiveSessionsRemoteDataSource {
  const FirebaseLiveSessionsRemoteDataSource({
    required FirestoreService firestoreService,
    required NetworkInfo networkInfo,
  }) : _firestoreService = firestoreService,
       _networkInfo = networkInfo;

  final FirestoreService _firestoreService;
  final NetworkInfo _networkInfo;

  @override
  Future<LiveSessionModel?> getLiveSession() {
    return _execute(() async {
      final stream = _firestoreService.streamCollection(
        collectionPath: FirestoreCollections.liveSessions,
        queryBuilder: _liveSessionQuery,
        includeMetadataChanges: true,
      );

      final isConnected = await _hasInternetConnection();

      if (!isConnected) {
        /*
         * While offline, use the first cached snapshot immediately.
         * If a cached live session exists, it will be displayed.
         * If the cache is empty, the result will be null.
         */
        final cachedSnapshot = await stream.first;

        return _mapLiveSession(cachedSnapshot);
      }

      /*
       * While online:
       * - Return immediately if a cached live session exists.
       * - Otherwise wait for the first confirmed server response.
       */
      final snapshot = await stream.firstWhere((snapshot) {
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

  Query<Map<String, dynamic>> _liveSessionQuery(
    CollectionReference<Map<String, dynamic>> collection,
  ) {
    return collection.limit(1);
  }

  Future<bool> _hasInternetConnection() async {
    try {
      return await _networkInfo.isConnected;
    } catch (_) {
      return false;
    }
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
    return FirebaseErrorHandler.execute<T>(operation);
  }
}
