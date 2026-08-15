import 'dart:io';

import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_content_types.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_folders.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_metadata_fields.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_service.dart';
import 'package:alwaleed_admain/features/lesson_exams/data/data_sources/lesson_exams_remote_data_source.dart';
import 'package:alwaleed_admain/features/lesson_exams/data/models/lesson_exam_question_model.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/lesson_exam_question_image_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseLessonExamsRemoteDataSource
    implements LessonExamsRemoteDataSource {
  const FirebaseLessonExamsRemoteDataSource({
    required FirestoreService firestoreService,
    required StorageService storageService,
  }) : _firestoreService = firestoreService,
       _storageService = storageService;

  final FirestoreService _firestoreService;
  final StorageService _storageService;

  @override
  Stream<List<LessonExamQuestionModel>> streamQuestions({
    required String lessonId,
  }) {
    return FirebaseErrorHandler.executeStream(() {
      return _firestoreService
          .streamCollection(
            collectionPath: FirestoreCollections.lessonQuestions,
            queryBuilder: _getQuestionsQuery(lessonId: lessonId),
          )
          .map(_mapQuestions);
    });
  }

  @override
  Future<void> createQuestion({
    required LessonExamQuestionModel question,
    LessonExamQuestionImageFile? image,
  }) {
    return FirebaseErrorHandler.execute(() async {
      _UploadedQuestionImage? uploadedImage;

      try {
        if (image != null) {
          uploadedImage = await _uploadQuestionImage(
            lessonId: question.lessonId,
            image: image,
          );
        }

        final data = Map<String, dynamic>.from(question.toCreateMap());

        data
          ..[FirestoreFields.questionImageUrl] = uploadedImage?.downloadUrl
          ..[FirestoreFields.questionImageStoragePath] =
              uploadedImage?.storagePath
          ..[FirestoreFields.createdAt] = FieldValue.serverTimestamp()
          ..[FirestoreFields.updatedAt] = FieldValue.serverTimestamp();

        await _firestoreService.postData(
          collectionPath: FirestoreCollections.lessonQuestions,
          data: data,
        );
      } catch (error, stackTrace) {
        await _tryDeleteStorageFile(storagePath: uploadedImage?.storagePath);

        Error.throwWithStackTrace(error, stackTrace);
      }
    }, timeout: null);
  }

  @override
  Future<void> updateQuestion({
    required LessonExamQuestionModel question,
    LessonExamQuestionImageFile? newImage,
    bool removeCurrentImage = false,
  }) {
    return FirebaseErrorHandler.execute(() async {
      final currentQuestion = await _getRequiredQuestion(
        lessonId: question.lessonId,
        questionId: question.questionId,
      );

      _UploadedQuestionImage? uploadedImage;

      try {
        if (newImage != null) {
          uploadedImage = await _uploadQuestionImage(
            lessonId: question.lessonId,
            image: newImage,
          );
        }

        final data = Map<String, dynamic>.from(question.toUpdateMap());

        data[FirestoreFields.updatedAt] = FieldValue.serverTimestamp();

        if (uploadedImage != null) {
          data
            ..[FirestoreFields.questionImageUrl] = uploadedImage.downloadUrl
            ..[FirestoreFields.questionImageStoragePath] =
                uploadedImage.storagePath;
        } else if (removeCurrentImage) {
          data
            ..[FirestoreFields.questionImageUrl] = null
            ..[FirestoreFields.questionImageStoragePath] = null;
        }

        await _firestoreService.patchData(
          collectionPath: FirestoreCollections.lessonQuestions,
          documentId: question.questionId,
          data: data,
        );
      } catch (error, stackTrace) {
        await _tryDeleteStorageFile(storagePath: uploadedImage?.storagePath);

        Error.throwWithStackTrace(error, stackTrace);
      }

      final oldStoragePath = currentQuestion.imageStoragePath;

      final imageWasChanged = uploadedImage != null || removeCurrentImage;

      final shouldDeleteOldImage =
          imageWasChanged &&
          oldStoragePath != null &&
          oldStoragePath.isNotEmpty &&
          oldStoragePath != uploadedImage?.storagePath;

      if (shouldDeleteOldImage) {
        await _tryDeleteStorageFile(storagePath: oldStoragePath);
      }
    }, timeout: null);
  }

  @override
  Future<void> deleteQuestion({
    required String lessonId,
    required String questionId,
  }) {
    return FirebaseErrorHandler.execute(() async {
      final currentQuestion = await _getRequiredQuestion(
        lessonId: lessonId,
        questionId: questionId,
      );

      await _firestoreService.deleteData(
        collectionPath: FirestoreCollections.lessonQuestions,
        documentId: questionId,
      );

      await _tryDeleteStorageFile(
        storagePath: currentQuestion.imageStoragePath,
      );
    }, timeout: null);
  }

  @override
  Future<void> saveCorrectAnswers({
    required String lessonId,
    required Map<String, int> correctChoiceIndexes,
  }) {
    return FirebaseErrorHandler.execute(() async {
      final questions = await _getQuestions(lessonId: lessonId);

      final questionIds = questions
          .map((question) => question.questionId)
          .toSet();

      for (final entry in correctChoiceIndexes.entries) {
        final questionId = entry.key;
        final correctChoiceIndex = entry.value;

        if (!questionIds.contains(questionId)) {
          FirebaseErrorHandler.throwFirestoreCode('not-found');
        }

        if (correctChoiceIndex < 0 || correctChoiceIndex > 3) {
          FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
        }
      }

      await Future.wait(
        correctChoiceIndexes.entries.map((entry) {
          return _firestoreService.patchData(
            collectionPath: FirestoreCollections.lessonQuestions,
            documentId: entry.key,
            data: {
              FirestoreFields.correctOption: entry.value,
              FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
            },
          );
        }),
      );
    }, timeout: null);
  }

  Future<List<LessonExamQuestionModel>> _getQuestions({
    required String lessonId,
  }) async {
    final snapshot = await _firestoreService.getCollection(
      collectionPath: FirestoreCollections.lessonQuestions,
      queryBuilder: _getQuestionsQuery(lessonId: lessonId),
    );

    return _mapQuestions(snapshot);
  }

  Future<LessonExamQuestionModel> _getRequiredQuestion({
    required String lessonId,
    required String questionId,
  }) async {
    final snapshot = await _firestoreService.getDocument(
      collectionPath: FirestoreCollections.lessonQuestions,
      documentId: questionId,
    );

    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    final question = LessonExamQuestionModel.fromFirestore(document: snapshot);

    if (question.lessonId != lessonId) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    return question;
  }

  FirestoreQueryBuilder _getQuestionsQuery({required String lessonId}) {
    return (collection) {
      return collection.where(FirestoreFields.lessonId, isEqualTo: lessonId);
    };
  }

  List<LessonExamQuestionModel> _mapQuestions(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final questions = snapshot.docs
        .map(
          (document) =>
              LessonExamQuestionModel.fromFirestore(document: document),
        )
        .toList();

    questions.sort(_compareQuestions);

    return List<LessonExamQuestionModel>.unmodifiable(questions);
  }

  int _compareQuestions(
    LessonExamQuestionModel first,
    LessonExamQuestionModel second,
  ) {
    final firstCreatedAt = first.createdAt;
    final secondCreatedAt = second.createdAt;

    if (firstCreatedAt == null && secondCreatedAt == null) {
      return first.questionId.compareTo(second.questionId);
    }

    if (firstCreatedAt == null) {
      return 1;
    }

    if (secondCreatedAt == null) {
      return -1;
    }

    final dateComparison = firstCreatedAt.compareTo(secondCreatedAt);

    if (dateComparison != 0) {
      return dateComparison;
    }

    return first.questionId.compareTo(second.questionId);
  }

  Future<_UploadedQuestionImage> _uploadQuestionImage({
    required String lessonId,
    required LessonExamQuestionImageFile image,
  }) async {
    if (image.bytes.isEmpty) {
      FirebaseErrorHandler.throwStorageCode('invalid-argument');
    }

    final storagePath = _buildImageStoragePath(lessonId: lessonId);

    File? temporaryFile;
    String? uploadedStoragePath;

    try {
      temporaryFile = await _createTemporaryImageFile(image: image);

      final uploadedMetadata = await _storageService.uploadFile(
        localFilePath: temporaryFile.path,
        storagePath: storagePath,
        contentType: StorageContentTypes.jpeg,
        customMetadata: {
          StorageMetadataFields.lessonId: lessonId,
          StorageMetadataFields.originalFileName: image.name,
        },
      );

      uploadedStoragePath = uploadedMetadata.fullPath;

      final downloadUrl = await _storageService.getDownloadUrl(
        storagePath: uploadedStoragePath,
      );

      return _UploadedQuestionImage(
        downloadUrl: downloadUrl,
        storagePath: uploadedStoragePath,
      );
    } catch (error, stackTrace) {
      await _tryDeleteStorageFile(storagePath: uploadedStoragePath);

      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      await _deleteTemporaryFile(temporaryFile);
    }
  }

  Future<File> _createTemporaryImageFile({
    required LessonExamQuestionImageFile image,
  }) async {
    final fileVersion = DateTime.now().microsecondsSinceEpoch;

    final separator = Platform.pathSeparator;

    final temporaryFile = File(
      '${Directory.systemTemp.path}'
      '${separator}lesson_question_'
      '$fileVersion.jpg',
    );

    await temporaryFile.writeAsBytes(image.bytes, flush: true);

    return temporaryFile;
  }

  String _buildImageStoragePath({required String lessonId}) {
    final fileVersion = DateTime.now().microsecondsSinceEpoch;

    return '${StorageFolders.lessonQuestionImages}/'
        '$lessonId/'
        '$fileVersion.jpg';
  }

  Future<void> _tryDeleteStorageFile({required String? storagePath}) async {
    final normalizedStoragePath = storagePath?.trim() ?? '';

    if (normalizedStoragePath.isEmpty) {
      return;
    }

    try {
      await _storageService.deleteFile(storagePath: normalizedStoragePath);
    } catch (_) {}
  }

  Future<void> _deleteTemporaryFile(File? file) async {
    if (file == null) {
      return;
    }

    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }
}

class _UploadedQuestionImage {
  const _UploadedQuestionImage({
    required this.downloadUrl,
    required this.storagePath,
  });

  final String downloadUrl;
  final String storagePath;
}
