import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admain/features/study_notes/data/models/study_note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'study_notes_remote_data_source.dart';

class FirebaseStudyNotesRemoteDataSource implements StudyNotesRemoteDataSource {
  const FirebaseStudyNotesRemoteDataSource({
    required FirestoreService firestoreService,
  }) : _firestoreService = firestoreService;

  final FirestoreService _firestoreService;

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
    return _execute(() async {
      final normalizedNoteId = noteId.trim();

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
  Future<void> createStudyNote({required StudyNoteModel note}) {
    return _execute(() async {
      await _firestoreService.postData(
        collectionPath: FirestoreCollections.studyNotes,
        documentId: note.noteId,
        data: note.toCreateMap(),
      );
    });
  }

  @override
  Future<void> updateStudyNote({required StudyNoteModel note}) {
    return _execute(() async {
      await _firestoreService.patchData(
        collectionPath: FirestoreCollections.studyNotes,
        documentId: note.noteId,
        data: note.toUpdateMap(),
      );
    });
  }

  @override
  Future<void> deleteStudyNote({required String noteId}) {
    return _execute(() async {
      await _firestoreService.deleteData(
        collectionPath: FirestoreCollections.studyNotes,
        documentId: noteId.trim(),
      );
    });
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
