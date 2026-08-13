import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_content_types.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_folders.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_metadata_fields.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_service.dart';
import 'package:alwaleed_admain/features/lessons/data/data_sources/lessons_remote_data_source.dart';
import 'package:alwaleed_admain/features/lessons/data/models/lesson_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseLessonsRemoteDataSource implements LessonsRemoteDataSource {
  const FirebaseLessonsRemoteDataSource({
    required FirestoreService firestoreService,
    required StorageService storageService,
  }) : _firestoreService = firestoreService,
       _storageService = storageService;

  final FirestoreService _firestoreService;
  final StorageService _storageService;

  @override
  Future<List<LessonModel>> getLessons({String? gradeId, bool? isPublished}) {
    return FirebaseErrorHandler.execute(() async {
      final snapshot = await _firestoreService.getCollection(
        collectionPath: FirestoreCollections.lessons,
        queryBuilder: _getLessonsQuery(
          gradeId: gradeId,
          isPublished: isPublished,
        ),
      );

      return _mapLessons(snapshot);
    });
  }

  @override
  Future<LessonModel> getLessonById({required String lessonId}) {
    return FirebaseErrorHandler.execute(() {
      return _getRequiredLesson(lessonId: lessonId);
    });
  }

  @override
  Stream<List<LessonModel>> streamLessons({
    String? gradeId,
    bool? isPublished,
  }) {
    return FirebaseErrorHandler.executeStream(() {
      return _firestoreService
          .streamCollection(
            collectionPath: FirestoreCollections.lessons,
            queryBuilder: _getLessonsQuery(
              gradeId: gradeId,
              isPublished: isPublished,
            ),
          )
          .map(_mapLessons);
    });
  }

  @override
  Future<void> createLesson({
    required LessonModel lesson,
    required String localPdfFilePath,
  }) {
    return FirebaseErrorHandler.execute(() async {
      final lessonId = lesson.lessonId.trim();
      final localPath = localPdfFilePath.trim();
      final pdfFileName = lesson.pdfFileName?.trim() ?? '';

      final newStoragePath = _buildPdfStoragePath(lessonId: lessonId);

      var didUploadPdf = false;

      try {
        final uploadedMetadata = await _storageService.uploadFile(
          localFilePath: localPath,
          storagePath: newStoragePath,
          contentType: StorageContentTypes.pdf,
          customMetadata: {
            StorageMetadataFields.lessonId: lessonId,
            StorageMetadataFields.originalFileName: pdfFileName,
          },
        );

        didUploadPdf = true;

        final persistedLesson = _copyLessonWithPdf(
          lesson: lesson,
          pdfStoragePath: uploadedMetadata.fullPath,
          pdfFileName: pdfFileName,
          pdfFileSize: uploadedMetadata.size ?? lesson.pdfFileSize ?? 0,
        );

        await _firestoreService.postData(
          collectionPath: FirestoreCollections.lessons,
          documentId: lessonId,
          data: persistedLesson.toCreateMap(),
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
  Future<void> updateLesson({
    required LessonModel lesson,
    String? replacementPdfFilePath,
  }) {
    return FirebaseErrorHandler.execute(() async {
      final lessonId = lesson.lessonId.trim();

      final currentLesson = await _getRequiredLesson(lessonId: lessonId);

      final replacementPath = replacementPdfFilePath?.trim();

      final hasReplacementPdf =
          replacementPath != null && replacementPath.isNotEmpty;

      if (!hasReplacementPdf) {
        final updatedLesson = _copyLessonWithPdf(
          lesson: lesson,
          pdfStoragePath: currentLesson.pdfStoragePath ?? '',
          pdfFileName: currentLesson.pdfFileName ?? '',
          pdfFileSize: currentLesson.pdfFileSize ?? 0,
        );

        await _firestoreService.patchData(
          collectionPath: FirestoreCollections.lessons,
          documentId: lessonId,
          data: updatedLesson.toUpdateMap(),
        );

        return;
      }

      final newPdfFileName = lesson.pdfFileName?.trim() ?? '';

      final newStoragePath = _buildPdfStoragePath(lessonId: lessonId);

      var didUploadNewPdf = false;

      try {
        final uploadedMetadata = await _storageService.uploadFile(
          localFilePath: replacementPath,
          storagePath: newStoragePath,
          contentType: StorageContentTypes.pdf,
          customMetadata: {
            StorageMetadataFields.lessonId: lessonId,
            StorageMetadataFields.originalFileName: newPdfFileName,
          },
        );

        didUploadNewPdf = true;

        final updatedLesson = _copyLessonWithPdf(
          lesson: lesson,
          pdfStoragePath: uploadedMetadata.fullPath,
          pdfFileName: newPdfFileName,
          pdfFileSize: uploadedMetadata.size ?? lesson.pdfFileSize ?? 0,
        );

        await _firestoreService.patchData(
          collectionPath: FirestoreCollections.lessons,
          documentId: lessonId,
          data: updatedLesson.toUpdateMap(),
        );
      } catch (error, stackTrace) {
        if (didUploadNewPdf) {
          await _rollbackStorageFile(storagePath: newStoragePath);
        }

        Error.throwWithStackTrace(error, stackTrace);
      }

      final oldStoragePath = currentLesson.pdfStoragePath?.trim() ?? '';

      if (oldStoragePath.isNotEmpty && oldStoragePath != newStoragePath) {
        await _deleteStorageFile(storagePath: oldStoragePath);
      }
    }, timeout: null);
  }

  @override
  Future<void> deleteLesson({required String lessonId}) {
    return FirebaseErrorHandler.execute(() async {
      final normalizedLessonId = lessonId.trim();

      final currentLesson = await _getRequiredLesson(
        lessonId: normalizedLessonId,
      );

      final storagePath = currentLesson.pdfStoragePath?.trim() ?? '';

      if (storagePath.isNotEmpty) {
        await _deleteStorageFile(storagePath: storagePath);
      }

      await _firestoreService.deleteData(
        collectionPath: FirestoreCollections.lessons,
        documentId: normalizedLessonId,
      );
    });
  }

  Future<LessonModel> _getRequiredLesson({required String lessonId}) async {
    final normalizedLessonId = lessonId.trim();

    final snapshot = await _firestoreService.getDocument(
      collectionPath: FirestoreCollections.lessons,
      documentId: normalizedLessonId,
    );

    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    return LessonModel.fromMap(documentId: snapshot.id, map: data);
  }

  LessonModel _copyLessonWithPdf({
    required LessonModel lesson,
    required String pdfStoragePath,
    required String pdfFileName,
    required int pdfFileSize,
  }) {
    return LessonModel(
      lessonId: lesson.lessonId,
      gradeId: lesson.gradeId,
      title: lesson.title,
      subtitle: lesson.subtitle,
      youtubeUrl: lesson.youtubeUrl,
      pdfStoragePath: pdfStoragePath,
      pdfFileName: pdfFileName,
      pdfFileSize: pdfFileSize,
      isPublished: lesson.isPublished,
      createdAt: lesson.createdAt,
      updatedAt: lesson.updatedAt,
    );
  }

  String _buildPdfStoragePath({required String lessonId}) {
    final fileVersion = DateTime.now().microsecondsSinceEpoch;

    return '${StorageFolders.lessons}/'
        '$lessonId/'
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
    } catch (_) {}
  }

  FirestoreQueryBuilder? _getLessonsQuery({
    String? gradeId,
    bool? isPublished,
  }) {
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

  List<LessonModel> _mapLessons(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final lessons = snapshot.docs.map((document) {
      return LessonModel.fromMap(documentId: document.id, map: document.data());
    }).toList();

    lessons.sort((first, second) {
      final firstCreatedAt = first.createdAt;
      final secondCreatedAt = second.createdAt;

      if (firstCreatedAt == null && secondCreatedAt == null) {
        return first.title.compareTo(second.title);
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
      return first.title.compareTo(second.title);
    });

    return List<LessonModel>.unmodifiable(lessons);
  }
}
