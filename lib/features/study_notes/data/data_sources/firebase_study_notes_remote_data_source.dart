import 'package:alwaleed_admin/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admin/core/firebase/storage/storage_content_types.dart';
import 'package:alwaleed_admin/core/firebase/storage/storage_folders.dart';
import 'package:alwaleed_admin/core/firebase/storage/storage_metadata_fields.dart';
import 'package:alwaleed_admin/core/firebase/storage/storage_service.dart';
import 'package:alwaleed_admin/features/study_notes/data/data_sources/study_notes_remote_data_source.dart';
import 'package:alwaleed_admin/features/study_notes/data/models/study_note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStudyNotesRemoteDataSource implements StudyNotesRemoteDataSource {
  const FirebaseStudyNotesRemoteDataSource({
    required FirestoreService firestoreService,
    required StorageService storageService,
  }) : _firestoreService = firestoreService,
       _storageService = storageService;

  final FirestoreService _firestoreService;
  final StorageService _storageService;

  @override
  Future<List<StudyNoteModel>> getStudyNotes({
    String? gradeId,
    bool? isPublished,
  }) {
    return FirebaseErrorHandler.execute(() async {
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
    return FirebaseErrorHandler.execute(() {
      return _getRequiredStudyNote(noteId: noteId);
    });
  }

  @override
  Stream<List<StudyNoteModel>> streamStudyNotes({
    String? gradeId,
    bool? isPublished,
  }) {
    return FirebaseErrorHandler.executeStream(() {
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
    return FirebaseErrorHandler.execute(() async {
      final normalizedNoteId = note.noteId.trim();

      final normalizedLocalPdfFilePath = localPdfFilePath.trim();

      final normalizedPdfFileName = note.pdfFileName.trim();

      final newStoragePath = _buildPdfStoragePath(noteId: normalizedNoteId);

      var didUploadPdf = false;

      try {
        final uploadedMetadata = await _storageService.uploadFile(
          localFilePath: normalizedLocalPdfFilePath,
          storagePath: newStoragePath,
          contentType: StorageContentTypes.pdf,
          customMetadata: {
            StorageMetadataFields.noteId: normalizedNoteId,
            StorageMetadataFields.originalFileName: normalizedPdfFileName,
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
          await _rollbackStorageFile(storagePath: newStoragePath);
        }

        Error.throwWithStackTrace(error, stackTrace);
      }
    }, timeout: null);
  }

  @override
  Future<void> updateStudyNote({
    required StudyNoteModel note,
    String? replacementPdfFilePath,
  }) {
    return FirebaseErrorHandler.execute(() async {
      final normalizedNoteId = note.noteId.trim();

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

      final normalizedPdfFileName = note.pdfFileName.trim();

      final newStoragePath = _buildPdfStoragePath(noteId: normalizedNoteId);

      var didUploadNewPdf = false;

      try {
        final uploadedMetadata = await _storageService.uploadFile(
          localFilePath: normalizedReplacementPath,
          storagePath: newStoragePath,
          contentType: StorageContentTypes.pdf,
          customMetadata: {
            StorageMetadataFields.noteId: normalizedNoteId,
            StorageMetadataFields.originalFileName: normalizedPdfFileName,
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
          await _rollbackStorageFile(storagePath: newStoragePath);
        }

        Error.throwWithStackTrace(error, stackTrace);
      }

      final oldStoragePath = currentNote.pdfStoragePath.trim();

      if (oldStoragePath.isNotEmpty && oldStoragePath != newStoragePath) {
        await _deleteStorageFile(storagePath: oldStoragePath);
      }
    }, timeout: null);
  }

  @override
  Future<void> deleteStudyNote({required String noteId}) {
    return FirebaseErrorHandler.execute(() async {
      final normalizedNoteId = noteId.trim();

      final currentNote = await _getRequiredStudyNote(noteId: normalizedNoteId);

      final currentStoragePath = currentNote.pdfStoragePath.trim();

      if (currentStoragePath.isNotEmpty) {
        await _deleteStorageFile(storagePath: currentStoragePath);
      }

      await _firestoreService.deleteData(
        collectionPath: FirestoreCollections.studyNotes,
        documentId: normalizedNoteId,
      );
    });
  }

  Future<StudyNoteModel> _getRequiredStudyNote({required String noteId}) async {
    final normalizedNoteId = noteId.trim();

    final snapshot = await _firestoreService.getDocument(
      collectionPath: FirestoreCollections.studyNotes,
      documentId: normalizedNoteId,
    );

    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
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
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    );
  }

  String _buildPdfStoragePath({required String noteId}) {
    final fileVersion = DateTime.now().microsecondsSinceEpoch;

    return '${StorageFolders.studyNotes}/'
        '$noteId/'
        '$fileVersion.pdf';
  }

  Future<void> _deleteStorageFile({required String storagePath}) {
    return _storageService.deleteFile(storagePath: storagePath.trim());
  }

  Future<void> _rollbackStorageFile({required String storagePath}) async {
    final normalizedStoragePath = storagePath.trim();

    if (normalizedStoragePath.isEmpty) {
      return;
    }

    try {
      await _storageService.deleteFile(storagePath: normalizedStoragePath);
    } catch (_) {
      // نحافظ على الخطأ الأصلي الذي أدى لتنفيذ الـrollback.
    }
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
      final firstCreatedAt = firstNote.createdAt;
      final secondCreatedAt = secondNote.createdAt;

      if (firstCreatedAt == null && secondCreatedAt == null) {
        return firstNote.name.compareTo(secondNote.name);
      }

      if (firstCreatedAt == null) {
        return 1;
      }

      if (secondCreatedAt == null) {
        return -1;
      }

      final dateComparison = secondCreatedAt.compareTo(firstCreatedAt);

      if (dateComparison != 0) {
        return dateComparison;
      }

      return firstNote.name.compareTo(secondNote.name);
    });

    return List<StudyNoteModel>.unmodifiable(notes);
  }
}
