import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_service.dart';
import 'package:alwaleed_admain/features/study_notes/data/models/study_note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'study_notes_remote_data_source.dart';

class FirebaseStudyNotesRemoteDataSource implements StudyNotesRemoteDataSource {
  const FirebaseStudyNotesRemoteDataSource({
    required FirestoreService firestoreService,
    required StorageService storageService,
  }) : _firestoreService = firestoreService,
       _storageService = storageService;

  static const String _pdfContentType = 'application/pdf';
  static const String _metadataNoteId = 'noteId';
  static const String _metadataOriginalFileName = 'originalFileName';

  final FirestoreService _firestoreService;
  final StorageService _storageService;

  @override
  Future<List<StudyNoteModel>> getStudyNotes({
    String? gradeId,
    bool? isPublished,
  }) {
    return _execute(() async {
      final snapshot = await _firestoreService.getCollection(
        collectionPath: FirestoreCollections.studyNotes,
        queryBuilder: _getNotesQuery(
          gradeId: gradeId,
          isPublished: isPublished,
        ),
      );

      return _mapStudyNotes(snapshot);
    });
  }

  @override
  Future<StudyNoteModel> getStudyNoteById({required String noteId}) {
    return _execute(() {
      return _getRequiredStudyNote(noteId: noteId);
    });
  }

  @override
  Stream<List<StudyNoteModel>> streamStudyNotes({
    String? gradeId,
    bool? isPublished,
  }) {
    return _executeStream(() {
      return _firestoreService
          .streamCollection(
            collectionPath: FirestoreCollections.studyNotes,
            queryBuilder: _getNotesQuery(
              gradeId: gradeId,
              isPublished: isPublished,
            ),
          )
          .map(_mapStudyNotes);
    });
  }

  @override
  Future<void> createStudyNote({
    required StudyNoteModel note,
    required String localPdfFilePath,
  }) {
    return _execute(() async {
      final normalizedNoteId = _normalizeRequiredValue(
        value: note.noteId,
        fieldName: 'noteId',
      );

      final normalizedLocalPdfFilePath = _normalizeRequiredValue(
        value: localPdfFilePath,
        fieldName: 'localPdfFilePath',
      );

      final normalizedPdfFileName = _normalizeRequiredValue(
        value: note.pdfFileName,
        fieldName: FirestoreFields.pdfFileName,
      );

      final newStoragePath = _buildPdfStoragePath(noteId: normalizedNoteId);

      var didUploadPdf = false;

      try {
        final uploadedMetadata = await _storageService.uploadFile(
          localFilePath: normalizedLocalPdfFilePath,
          storagePath: newStoragePath,
          contentType: _pdfContentType,
          customMetadata: {
            _metadataNoteId: normalizedNoteId,
            _metadataOriginalFileName: normalizedPdfFileName,
          },
        );

        didUploadPdf = true;

        final persistedNote = _copyNoteWithPdf(
          note: note,
          pdfStoragePath: uploadedMetadata.fullPath,
          pdfFileName: normalizedPdfFileName,
          pdfFileSize: uploadedMetadata.size ?? note.pdfFileSize,
        );

        await _firestoreService.postData(
          collectionPath: FirestoreCollections.studyNotes,
          documentId: normalizedNoteId,
          data: persistedNote.toCreateMap(),
        );
      } catch (error, stackTrace) {
        if (didUploadPdf) {
          await _tryDeleteStorageFile(storagePath: newStoragePath);
        }

        Error.throwWithStackTrace(error, stackTrace);
      }
    });
  }

  @override
  Future<void> updateStudyNote({
    required StudyNoteModel note,
    String? replacementPdfFilePath,
  }) {
    return _execute(() async {
      final normalizedNoteId = _normalizeRequiredValue(
        value: note.noteId,
        fieldName: 'noteId',
      );

      final currentNote = await _getRequiredStudyNote(noteId: normalizedNoteId);

      final normalizedReplacementPath = replacementPdfFilePath?.trim();

      final hasReplacementPdf =
          normalizedReplacementPath != null &&
          normalizedReplacementPath.isNotEmpty;

      if (!hasReplacementPdf) {
        final updatedNote = _copyNoteWithPdf(
          note: note,
          pdfStoragePath: currentNote.pdfStoragePath,
          pdfFileName: currentNote.pdfFileName,
          pdfFileSize: currentNote.pdfFileSize,
        );

        await _firestoreService.patchData(
          collectionPath: FirestoreCollections.studyNotes,
          documentId: normalizedNoteId,
          data: updatedNote.toUpdateMap(),
        );

        return;
      }

      final normalizedPdfFileName = _normalizeRequiredValue(
        value: note.pdfFileName,
        fieldName: FirestoreFields.pdfFileName,
      );

      final newStoragePath = _buildPdfStoragePath(noteId: normalizedNoteId);

      var didUploadNewPdf = false;

      try {
        final uploadedMetadata = await _storageService.uploadFile(
          localFilePath: normalizedReplacementPath,
          storagePath: newStoragePath,
          contentType: _pdfContentType,
          customMetadata: {
            _metadataNoteId: normalizedNoteId,
            _metadataOriginalFileName: normalizedPdfFileName,
          },
        );

        didUploadNewPdf = true;

        final updatedNote = _copyNoteWithPdf(
          note: note,
          pdfStoragePath: uploadedMetadata.fullPath,
          pdfFileName: normalizedPdfFileName,
          pdfFileSize: uploadedMetadata.size ?? note.pdfFileSize,
        );

        await _firestoreService.patchData(
          collectionPath: FirestoreCollections.studyNotes,
          documentId: normalizedNoteId,
          data: updatedNote.toUpdateMap(),
        );
      } catch (error, stackTrace) {
        if (didUploadNewPdf) {
          await _tryDeleteStorageFile(storagePath: newStoragePath);
        }

        Error.throwWithStackTrace(error, stackTrace);
      }

      final oldStoragePath = currentNote.pdfStoragePath.trim();

      if (oldStoragePath.isNotEmpty && oldStoragePath != newStoragePath) {
        await _tryDeleteStorageFile(storagePath: oldStoragePath);
      }
    });
  }

  @override
  Future<void> deleteStudyNote({required String noteId}) {
    return _execute(() async {
      final normalizedNoteId = _normalizeRequiredValue(
        value: noteId,
        fieldName: 'noteId',
      );

      final currentNote = await _getRequiredStudyNote(noteId: normalizedNoteId);

      await _firestoreService.deleteData(
        collectionPath: FirestoreCollections.studyNotes,
        documentId: normalizedNoteId,
      );

      final currentStoragePath = currentNote.pdfStoragePath.trim();

      if (currentStoragePath.isNotEmpty) {
        await _tryDeleteStorageFile(storagePath: currentStoragePath);
      }
    });
  }

  Future<StudyNoteModel> _getRequiredStudyNote({required String noteId}) async {
    final normalizedNoteId = _normalizeRequiredValue(
      value: noteId,
      fieldName: 'noteId',
    );

    final snapshot = await _firestoreService.getDocument(
      collectionPath: FirestoreCollections.studyNotes,
      documentId: normalizedNoteId,
    );

    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      throw FirebaseRemoteException(
        errorModel: FirebaseErrorHandler.handleFirestoreCode('not-found'),
      );
    }

    return StudyNoteModel.fromMap(documentId: snapshot.id, map: data);
  }

  StudyNoteModel _copyNoteWithPdf({
    required StudyNoteModel note,
    required String pdfStoragePath,
    required String pdfFileName,
    required int pdfFileSize,
  }) {
    return StudyNoteModel(
      noteId: note.noteId,
      name: note.name,
      description: note.description,
      gradeId: note.gradeId,
      isPublished: note.isPublished,
      pdfStoragePath: pdfStoragePath,
      pdfFileName: pdfFileName,
      pdfFileSize: pdfFileSize,
    );
  }

  String _buildPdfStoragePath({required String noteId}) {
    final fileVersion = DateTime.now().microsecondsSinceEpoch;
    return '${FirestoreCollections.studyNotes}/'
        '$noteId/'
        '$fileVersion.pdf';
  }

  String _normalizeRequiredValue({
    required String value,
    required String fieldName,
  }) {
    final normalizedValue = value.trim();

    if (normalizedValue.isNotEmpty) {
      return normalizedValue;
    }

    throw FirebaseException(
      plugin: 'firebase_storage',
      code: 'invalid-argument',
      message: '$fieldName cannot be empty.',
    );
  }

  Future<void> _tryDeleteStorageFile({required String storagePath}) async {
    final normalizedStoragePath = storagePath.trim();

    if (normalizedStoragePath.isEmpty) {
      return;
    }

    try {
      await _storageService.deleteFile(storagePath: normalizedStoragePath);
    } catch (_) {}
  }

  FirestoreQueryBuilder? _getNotesQuery({String? gradeId, bool? isPublished}) {
    final normalizedGradeId = gradeId?.trim();

    final hasGradeFilter =
        normalizedGradeId != null && normalizedGradeId.isNotEmpty;

    final hasPublicationFilter = isPublished != null;

    if (!hasGradeFilter && !hasPublicationFilter) {
      return null;
    }

    return (collection) {
      Query<Map<String, dynamic>> query = collection;

      if (hasGradeFilter) {
        query = query.where(
          FirestoreFields.gradeId,
          isEqualTo: normalizedGradeId,
        );
      }

      if (hasPublicationFilter) {
        query = query.where(
          FirestoreFields.isPublished,
          isEqualTo: isPublished,
        );
      }

      return query;
    };
  }

  List<StudyNoteModel> _mapStudyNotes(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final notes = snapshot.docs.map((document) {
      return StudyNoteModel.fromMap(
        documentId: document.id,
        map: document.data(),
      );
    }).toList();

    notes.sort((firstNote, secondNote) {
      return firstNote.name.compareTo(secondNote.name);
    });

    return notes;
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
