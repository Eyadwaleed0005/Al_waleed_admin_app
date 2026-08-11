import 'dart:convert';
import 'dart:developer' as developer;

import 'package:alwaleed_admain/core/connection/network/network_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'firestore_service.dart';

class FirebaseFirestoreService implements FirestoreService {
  FirebaseFirestoreService({
    required NetworkInfo networkInfo,
    FirebaseFirestore? firestore,
    this.enableLogging = kDebugMode,
    this.logRequestData = true,
    this.logResponseData = true,
    this.maxLoggedDocuments = 20,
  }) : _networkInfo = networkInfo,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final NetworkInfo _networkInfo;

  final bool enableLogging;
  final bool logRequestData;
  final bool logResponseData;
  final int maxLoggedDocuments;

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collectionPath,
    required String documentId,
  }) {
    final path = '$collectionPath/$documentId';

    return _execute(
      operation: 'GET DOCUMENT',
      path: path,
      action: () {
        /*
         * Do not check the internet here.
         * Firestore can return cached data while the device is offline.
         */
        return _firestore.collection(collectionPath).doc(documentId).get();
      },
    );
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getCollection({
    required String collectionPath,
    FirestoreQueryBuilder? queryBuilder,
  }) {
    return _execute(
      operation: 'GET COLLECTION',
      path: collectionPath,
      requestData: {'customQuery': queryBuilder != null},
      action: () {
        /*
         * Do not check the internet here.
         * Firestore can return cached data while the device is offline.
         */
        final collection = _firestore.collection(collectionPath);
        final query = queryBuilder?.call(collection) ?? collection;

        return query.get();
      },
    );
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument({
    required String collectionPath,
    required String documentId,
    bool includeMetadataChanges = false,
  }) {
    final path = '$collectionPath/$documentId';

    return _watch(
      operation: 'STREAM DOCUMENT',
      path: path,
      requestData: {'includeMetadataChanges': includeMetadataChanges},
      streamBuilder: () {
        return _firestore
            .collection(collectionPath)
            .doc(documentId)
            .snapshots(includeMetadataChanges: includeMetadataChanges);
      },
    );
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required String collectionPath,
    FirestoreQueryBuilder? queryBuilder,
    bool includeMetadataChanges = false,
  }) {
    return _watch(
      operation: 'STREAM COLLECTION',
      path: collectionPath,
      requestData: {
        'customQuery': queryBuilder != null,
        'includeMetadataChanges': includeMetadataChanges,
      },
      streamBuilder: () {
        final collection = _firestore.collection(collectionPath);
        final query = queryBuilder?.call(collection) ?? collection;

        return query.snapshots(includeMetadataChanges: includeMetadataChanges);
      },
    );
  }

  @override
  Future<String> postData({
    required String collectionPath,
    required Map<String, dynamic> data,
    String? documentId,
  }) {
    final normalizedDocumentId = documentId?.trim();

    final hasDocumentId =
        normalizedDocumentId != null && normalizedDocumentId.isNotEmpty;

    final path = hasDocumentId
        ? '$collectionPath/$normalizedDocumentId'
        : collectionPath;

    return _execute(
      operation: 'POST',
      path: path,
      requestData: data,
      action: () async {
        /*
         * Check the connection before creating the Firestore write.
         * If there is no internet, the write is never sent to Firestore.
         */
        await _requireInternetConnection();

        final collection = _firestore.collection(collectionPath);

        if (normalizedDocumentId != null && normalizedDocumentId.isNotEmpty) {
          await collection.doc(normalizedDocumentId).set(data);

          return normalizedDocumentId;
        }

        final document = await collection.add(data);

        return document.id;
      },
    );
  }

  @override
  Future<void> patchData({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
  }) {
    final documentReference = _firestore
        .collection(collectionPath)
        .doc(documentId);

    return _execute(
      operation: 'PATCH',
      path: documentReference.path,
      requestData: data,
      action: () async {
        /*
         * Prevent update() from being called when the device is offline.
         */
        await _requireInternetConnection();

        final snapshot = await documentReference.get(
          const GetOptions(source: Source.server),
        );

        if (!snapshot.exists) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: 'The requested document was not found.',
          );
        }

        await documentReference.update(data);
      },
    );
  }

  @override
  Future<void> deleteData({
    required String collectionPath,
    required String documentId,
  }) {
    final documentReference = _firestore
        .collection(collectionPath)
        .doc(documentId);

    return _execute(
      operation: 'DELETE',
      path: documentReference.path,
      action: () async {
        /*
         * Prevent delete() from being called when the device is offline.
         */
        await _requireInternetConnection();

        await documentReference.delete();
      },
    );
  }

  Future<void> _requireInternetConnection() async {
    bool isConnected = false;

    try {
      isConnected = await _networkInfo.isConnected;
    } catch (_) {
      isConnected = false;
    }

    if (isConnected) {
      return;
    }

    throw FirebaseException(
      plugin: 'cloud_firestore',
      code: 'no-internet',
      message: 'No internet connection is currently available.',
    );
  }

  Future<T> _execute<T>({
    required String operation,
    required String path,
    required Future<T> Function() action,
    Object? requestData,
  }) async {
    _logRequest(operation: operation, path: path, data: requestData);

    final stopwatch = Stopwatch()..start();

    try {
      final result = await action();

      stopwatch.stop();

      _logResponse(
        operation: operation,
        path: path,
        response: result,
        duration: stopwatch.elapsed,
      );

      return result;
    } catch (error, stackTrace) {
      stopwatch.stop();

      _logError(
        operation: operation,
        path: path,
        error: error,
        stackTrace: stackTrace,
        duration: stopwatch.elapsed,
      );

      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Stream<T> _watch<T>({
    required String operation,
    required String path,
    required Stream<T> Function() streamBuilder,
    Object? requestData,
  }) async* {
    _logRequest(operation: operation, path: path, data: requestData);

    try {
      await for (final event in streamBuilder()) {
        _logResponse(operation: operation, path: path, response: event);

        yield event;
      }
    } catch (error, stackTrace) {
      _logError(
        operation: operation,
        path: path,
        error: error,
        stackTrace: stackTrace,
      );

      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void _logRequest({
    required String operation,
    required String path,
    Object? data,
  }) {
    if (!_canLog) {
      return;
    }

    final buffer = StringBuffer()
      ..writeln('┌──────────── FIRESTORE REQUEST ────────────')
      ..writeln('│ Operation: $operation')
      ..writeln('│ Path: $path');

    if (logRequestData && data != null) {
      buffer
        ..writeln('│ Data:')
        ..writeln(_addLinePrefix(_prettyPrint(data)));
    }

    buffer.writeln('└──────────────────────────────────────────');

    developer.log(buffer.toString(), name: 'FirebaseFirestoreService');
  }

  void _logResponse({
    required String operation,
    required String path,
    Object? response,
    Duration? duration,
  }) {
    if (!_canLog) {
      return;
    }

    final buffer = StringBuffer()
      ..writeln('┌──────────── FIRESTORE RESPONSE ───────────')
      ..writeln('│ Operation: $operation')
      ..writeln('│ Path: $path');

    if (duration != null) {
      buffer.writeln('│ Duration: ${duration.inMilliseconds} ms');
    }

    if (logResponseData) {
      buffer
        ..writeln('│ Data:')
        ..writeln(_addLinePrefix(_prettyPrint(_formatResponse(response))));
    }

    buffer.writeln('└──────────────────────────────────────────');

    developer.log(buffer.toString(), name: 'FirebaseFirestoreService');
  }

  void _logError({
    required String operation,
    required String path,
    required Object error,
    required StackTrace stackTrace,
    Duration? duration,
  }) {
    if (!_canLog) {
      return;
    }

    final buffer = StringBuffer()
      ..writeln('┌───────────── FIRESTORE ERROR ─────────────')
      ..writeln('│ Operation: $operation')
      ..writeln('│ Path: $path');

    if (duration != null) {
      buffer.writeln('│ Duration: ${duration.inMilliseconds} ms');
    }

    buffer
      ..writeln('│ Error: $error')
      ..writeln('└──────────────────────────────────────────');

    developer.log(
      buffer.toString(),
      name: 'FirebaseFirestoreService',
      error: error,
      stackTrace: stackTrace,
    );
  }

  Object? _formatResponse(Object? response) {
    if (response == null) {
      return {'status': 'success'};
    }

    if (response is DocumentSnapshot<Map<String, dynamic>>) {
      return {
        'documentId': response.id,
        'exists': response.exists,
        'fromCache': response.metadata.isFromCache,
        'data': response.data(),
      };
    }

    if (response is QuerySnapshot<Map<String, dynamic>>) {
      final documents = response.docs
          .take(maxLoggedDocuments)
          .map(
            (document) => {'documentId': document.id, 'data': document.data()},
          )
          .toList();

      return {
        'documentsCount': response.docs.length,
        'loggedDocuments': documents.length,
        'isTruncated': response.docs.length > maxLoggedDocuments,
        'fromCache': response.metadata.isFromCache,
        'documents': documents,
      };
    }

    if (response is String) {
      return {'documentId': response, 'status': 'success'};
    }

    return response;
  }

  String _prettyPrint(Object? value) {
    try {
      return const JsonEncoder.withIndent(
        '  ',
      ).convert(_convertToLoggableValue(value));
    } catch (_) {
      return value.toString();
    }
  }

  Object? _convertToLoggableValue(Object? value) {
    if (value == null || value is String || value is num || value is bool) {
      return value;
    }

    if (value is DateTime) {
      return value.toIso8601String();
    }

    if (value is Timestamp) {
      return value.toDate().toIso8601String();
    }

    if (value is GeoPoint) {
      return {'latitude': value.latitude, 'longitude': value.longitude};
    }

    if (value is DocumentReference) {
      return value.path;
    }

    if (value is Map) {
      return value.map((key, item) {
        return MapEntry(key.toString(), _convertToLoggableValue(item));
      });
    }

    if (value is Iterable) {
      return value.map(_convertToLoggableValue).toList();
    }

    return value.toString();
  }

  String _addLinePrefix(String value) {
    return value.split('\n').map((line) => '│ $line').join('\n');
  }

  bool get _canLog {
    return enableLogging && kDebugMode;
  }
}
