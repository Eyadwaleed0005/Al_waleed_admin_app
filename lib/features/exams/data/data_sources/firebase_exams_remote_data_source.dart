import 'dart:developer' as developer;

import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_content_types.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_folders.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_metadata_fields.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_service.dart';
import 'package:alwaleed_admain/features/exams/data/data_sources/exams_remote_data_source.dart';
import 'package:alwaleed_admain/features/exams/data/models/exam_model.dart';
import 'package:alwaleed_admain/features/exams/data/models/exam_question_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseExamsRemoteDataSource implements ExamsRemoteDataSource {
  const FirebaseExamsRemoteDataSource({
    required FirestoreService firestoreService,
    required StorageService storageService,
    required FirebaseFirestore firebaseFirestore,
  }) : _firestoreService = firestoreService,
       _storageService = storageService,
       _firestore = firebaseFirestore;

  final FirestoreService _firestoreService;
  final StorageService _storageService;
  final FirebaseFirestore _firestore;

  static const String _isDeletingField = 'isDeleting';

  // حد تطبيقي للحفظ في Batch واحدة.
  static const int _maxQuestionsPerExam = 400;

  CollectionReference<Map<String, dynamic>> get _exams {
    return _firestore.collection(FirestoreCollections.exams);
  }

  CollectionReference<Map<String, dynamic>> get _questions {
    return _firestore.collection(FirestoreCollections.examQuestions);
  }

  @override
  Future<List<ExamModel>> getExams({String? gradeId, ExamStatus? status}) {
    return FirebaseErrorHandler.execute(() async {
      final snapshot = await _firestoreService.getCollection(
        collectionPath: FirestoreCollections.exams,
        queryBuilder: _getExamsQuery(gradeId: gradeId, status: status),
      );

      return _mapExams(snapshot);
    });
  }

  @override
  Stream<List<ExamModel>> streamExams({String? gradeId, ExamStatus? status}) {
    return FirebaseErrorHandler.executeStream(() {
      return _firestoreService
          .streamCollection(
            collectionPath: FirestoreCollections.exams,
            queryBuilder: _getExamsQuery(gradeId: gradeId, status: status),
          )
          .map(_mapExams);
    });
  }

  @override
  Future<ExamModel> getExamById({required String examId}) {
    return FirebaseErrorHandler.execute(() async {
      final String id = _requireId(examId);

      final document = await _firestoreService.getDocument(
        collectionPath: FirestoreCollections.exams,
        documentId: id,
      );

      final data = _requireData(document);
      _ensureNotDeleting(data);

      final questionsSnapshot = await _firestoreService.getCollection(
        collectionPath: FirestoreCollections.examQuestions,
        queryBuilder: (collection) {
          return collection.where(FirestoreFields.examId, isEqualTo: id);
        },
      );

      final questions = questionsSnapshot.docs
          .map(ExamQuestionModel.fromFirestore)
          .toList();

      questions.sort(_compareQuestions);

      final exam = ExamModel.fromFirestore(document);

      return ExamModel(
        examId: exam.examId,
        gradeId: exam.gradeId,
        examName: exam.examName,
        durationMinutes: exam.durationMinutes,
        questionCount: exam.questionCount,
        totalScore: exam.totalScore,
        status: exam.status,
        questions: List<ExamQuestionModel>.unmodifiable(questions),
        firstAttemptAt: exam.firstAttemptAt,
        closedAt: exam.closedAt,
        createdAt: exam.createdAt,
        updatedAt: exam.updatedAt,
      );
    });
  }

  @override
  Future<String> createExam({
    required ExamModel exam,
    required List<ExamQuestionModel> questions,
    required Map<String, ExamQuestionImageFile> questionImages,
  }) {
    return FirebaseErrorHandler.execute(() async {
      _validateExam(
        exam: exam,
        questions: questions,
        questionImages: questionImages,
      );

      final examReference = _exams.doc();
      final batch = _firestore.batch();
      final List<String> uploadedPaths = [];

      bool commitStarted = false;

      try {
        for (int index = 0; index < questions.length; index++) {
          final question = questions[index];

          // يحافظ على ترتيب الأسئلة عند تساوي createdAt.
          final String questionId =
              '${examReference.id}_${index.toString().padLeft(4, '0')}';

          final questionReference = _questions.doc(questionId);
          final image = questionImages[question.questionId];

          String? imageUrl;
          String? imageStoragePath;

          if (image != null) {
            imageStoragePath = _newImagePath(
              examId: examReference.id,
              questionId: questionId,
              imageName: image.name,
            );

            // نسجل المسار قبل الرفع لتنظيفه إذا فشل تجهيز الامتحان.
            uploadedPaths.add(imageStoragePath);

            imageUrl = await _uploadImage(
              image: image,
              examId: examReference.id,
              questionId: questionId,
              storagePath: imageStoragePath,
            );
          }

          final questionModel = ExamQuestionModel(
            questionId: questionId,
            examId: examReference.id,
            questionText: question.questionText.trim(),
            degree: question.degree,
            choices: List<String>.unmodifiable(
              question.choices.map((choice) => choice.trim()),
            ),
            correctChoiceIndex: question.correctChoiceIndex,
            imageUrl: imageUrl,
            imageStoragePath: imageStoragePath,
          );

          batch.set(questionReference, questionModel.toCreateMap());
        }

        batch.set(examReference, {
          FirestoreFields.gradeId: exam.gradeId.trim(),
          FirestoreFields.examName: exam.examName.trim(),
          FirestoreFields.durationMinutes: exam.durationMinutes,
          FirestoreFields.questionCount: questions.length,
          FirestoreFields.totalScore: exam.totalScore,
          FirestoreFields.examStatus: ExamModel.statusToJson(exam.status),
          FirestoreFields.firstAttemptAt: null,
          FirestoreFields.closedAt: null,
          FirestoreFields.createdAt: FieldValue.serverTimestamp(),
          FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
          _isDeletingField: false,
        });

        commitStarted = true;
        await batch.commit();

        return examReference.id;
      } catch (error, stackTrace) {
        if (!commitStarted) {
          for (final path in uploadedPaths.reversed) {
            await _deleteImageBestEffort(path);
          }
        } else {
          // لا نحذف الصور عند غموض نتيجة الـ commit.
          // قد يكون الحفظ نجح على الخادم وانقطع الرد.
          developer.log(
            'Create commit failed; retained images for reconciliation. '
            'examId=${examReference.id}',
            name: 'FirebaseExamsRemoteDataSource',
            error: error,
            stackTrace: stackTrace,
          );
        }

        Error.throwWithStackTrace(error, stackTrace);
      }
    }, timeout: null);
  }

  @override
  Future<void> updateExam({required ExamModel exam}) {
    return FirebaseErrorHandler.execute(() async {
      final String examId = _requireId(exam.examId);

      if (exam.gradeId.trim().isEmpty ||
          exam.examName.trim().isEmpty ||
          exam.durationMinutes <= 0) {
        FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
      }

      final reference = _exams.doc(examId);

      await _firestore.runTransaction<void>((transaction) async {
        final snapshot = await transaction.get(reference);
        final data = _requireData(snapshot);

        _ensureNotDeleting(data);

        final current = ExamModel.fromFirestore(snapshot);

        if (current.status == ExamStatus.ended) {
          FirebaseErrorHandler.throwFirestoreCode('failed-precondition');
        }

        final bool settingsChanged =
            current.gradeId != exam.gradeId.trim() ||
            current.examName != exam.examName.trim() ||
            current.durationMinutes != exam.durationMinutes;

        final bool hasStarted = data[FirestoreFields.firstAttemptAt] != null;

        // بعد بدء المحاولات نسمح بالإغلاق فقط.
        if (hasStarted &&
            (exam.status != ExamStatus.ended || settingsChanged)) {
          FirebaseErrorHandler.throwFirestoreCode('failed-precondition');
        }

        if (exam.status == ExamStatus.published && current.questionCount <= 0) {
          FirebaseErrorHandler.throwFirestoreCode('failed-precondition');
        }

        transaction.update(reference, {
          FirestoreFields.gradeId: exam.gradeId.trim(),
          FirestoreFields.examName: exam.examName.trim(),
          FirestoreFields.durationMinutes: exam.durationMinutes,
          FirestoreFields.examStatus: ExamModel.statusToJson(exam.status),
          if (exam.status == ExamStatus.ended)
            FirestoreFields.closedAt: FieldValue.serverTimestamp(),
          FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
        });
      });
    }, timeout: null);
  }

  @override
  Future<void> updateQuestion({
    required ExamQuestionModel question,
    ExamQuestionImageFile? newImage,
    required bool removeCurrentImage,
  }) {
    return FirebaseErrorHandler.execute(() async {
      _validateQuestion(question);

      final String examId = _requireId(question.examId);
      final String questionId = _requireId(question.questionId);

      if (newImage != null && removeCurrentImage) {
        FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
      }

      final examReference = _exams.doc(examId);
      final questionReference = _questions.doc(questionId);

      // فحص مبكر قبل رفع الصورة، ثم نعيد الفحص داخل Transaction.
      final initialExam = await examReference.get(
        const GetOptions(source: Source.server),
      );
      _ensureQuestionsEditable(_requireData(initialExam));

      final initialQuestion = await questionReference.get(
        const GetOptions(source: Source.server),
      );
      _ensureQuestionBelongsToExam(_requireData(initialQuestion), examId);

      String? newPath;
      String? newUrl;

      if (newImage != null) {
        newPath = _newImagePath(
          examId: examId,
          questionId: questionId,
          imageName: newImage.name,
        );

        try {
          newUrl = await _uploadImage(
            image: newImage,
            examId: examId,
            questionId: questionId,
            storagePath: newPath,
          );
        } catch (error, stackTrace) {
          await _deleteImageBestEffort(newPath);
          Error.throwWithStackTrace(error, stackTrace);
        }
      }

      String? obsoleteImagePath;

      try {
        obsoleteImagePath = await _firestore.runTransaction<String?>((
          transaction,
        ) async {
          final examSnapshot = await transaction.get(examReference);
          final questionSnapshot = await transaction.get(questionReference);

          final examData = _requireData(examSnapshot);
          final questionData = _requireData(questionSnapshot);

          _ensureQuestionsEditable(examData);
          _ensureQuestionBelongsToExam(questionData, examId);

          final currentExam = ExamModel.fromFirestore(examSnapshot);
          final currentQuestion = ExamQuestionModel.fromFirestore(
            questionSnapshot,
          );

          final int newTotal =
              currentExam.totalScore - currentQuestion.degree + question.degree;

          if (newTotal < 0) {
            FirebaseErrorHandler.throwFirestoreCode('failed-precondition');
          }

          final bool changesImage = newImage != null || removeCurrentImage;

          transaction.update(questionReference, {
            FirestoreFields.questionText: question.questionText.trim(),
            FirestoreFields.questionScore: question.degree,
            FirestoreFields.option1: question.choices[0].trim(),
            FirestoreFields.option2: question.choices[1].trim(),
            FirestoreFields.option3: question.choices[2].trim(),
            FirestoreFields.option4: question.choices[3].trim(),
            FirestoreFields.correctOption: question.correctChoiceIndex,
            if (changesImage) FirestoreFields.questionImageUrl: newUrl,
            if (changesImage) FirestoreFields.questionImageStoragePath: newPath,
            FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
          });

          transaction.update(examReference, {
            FirestoreFields.totalScore: newTotal,
            FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
          });

          return changesImage ? currentQuestion.imageStoragePath : null;
        });
      } catch (error, stackTrace) {
        // نحتفظ بالصورة الجديدة عند غموض نتيجة الكتابة.
        if (newPath != null) {
          developer.log(
            'Question update failed; retained image: $newPath',
            name: 'FirebaseExamsRemoteDataSource',
            error: error,
            stackTrace: stackTrace,
          );
        }

        Error.throwWithStackTrace(error, stackTrace);
      }

      if (obsoleteImagePath != null && obsoleteImagePath != newPath) {
        await _deleteImageBestEffort(obsoleteImagePath);
      }
    }, timeout: null);
  }

  @override
  Future<void> deleteQuestion({
    required String examId,
    required String questionId,
  }) {
    return FirebaseErrorHandler.execute(() async {
      final String normalizedExamId = _requireId(examId);
      final String normalizedQuestionId = _requireId(questionId);

      final examReference = _exams.doc(normalizedExamId);
      final questionReference = _questions.doc(normalizedQuestionId);

      final String? imagePath = await _firestore.runTransaction<String?>((
        transaction,
      ) async {
        final examSnapshot = await transaction.get(examReference);
        final questionSnapshot = await transaction.get(questionReference);

        final examData = _requireData(examSnapshot);
        _ensureQuestionsEditable(examData);

        if (!questionSnapshot.exists) {
          return null;
        }

        final questionData = _requireData(questionSnapshot);
        _ensureQuestionBelongsToExam(questionData, normalizedExamId);

        final exam = ExamModel.fromFirestore(examSnapshot);
        final question = ExamQuestionModel.fromFirestore(questionSnapshot);

        final int newCount = exam.questionCount - 1;
        final int newTotal = exam.totalScore - question.degree;

        if (newCount < 0 || newTotal < 0) {
          FirebaseErrorHandler.throwFirestoreCode('failed-precondition');
        }

        transaction.delete(questionReference);

        transaction.update(examReference, {
          FirestoreFields.questionCount: newCount,
          FirestoreFields.totalScore: newTotal,
          if (newCount == 0)
            FirestoreFields.examStatus: ExamModel.statusToJson(
              ExamStatus.unpublished,
            ),
          FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
        });

        return question.imageStoragePath;
      });

      if (imagePath != null) {
        await _deleteImageBestEffort(imagePath);
      }
    }, timeout: null);
  }

  @override
  Future<void> deleteExam({required String examId}) {
    return FirebaseErrorHandler.execute(() async {
      final String id = _requireId(examId);
      final reference = _exams.doc(id);

      // نحافظ على نتائج الطلاب ولا نحذفها ضمن هذه العملية.
      final results = await _firestore
          .collection(FirestoreCollections.examResults)
          .where(FirestoreFields.examId, isEqualTo: id)
          .limit(1)
          .get(const GetOptions(source: Source.server));

      if (results.docs.isNotEmpty) {
        FirebaseErrorHandler.throwFirestoreCode('failed-precondition');
      }

      final bool exists = await _firestore.runTransaction<bool>((
        transaction,
      ) async {
        final snapshot = await transaction.get(reference);

        if (!snapshot.exists) {
          return false;
        }

        final data = _requireData(snapshot);

        if (data[FirestoreFields.firstAttemptAt] != null) {
          FirebaseErrorHandler.throwFirestoreCode('failed-precondition');
        }

        transaction.update(reference, {
          _isDeletingField: true,
          FirestoreFields.examStatus: ExamModel.statusToJson(
            ExamStatus.unpublished,
          ),
          FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
        });

        return true;
      });

      if (!exists) {
        return;
      }

      // حذف على دفعات صغيرة، ويمكن إعادة المحاولة إذا انقطع التنفيذ.
      while (true) {
        final snapshot = await _questions
            .where(FirestoreFields.examId, isEqualTo: id)
            .limit(100)
            .get(const GetOptions(source: Source.server));

        if (snapshot.docs.isEmpty) {
          break;
        }

        for (final document in snapshot.docs) {
          final question = ExamQuestionModel.fromFirestore(document);
          final String? path = question.imageStoragePath;

          if (path != null && path.trim().isNotEmpty) {
            // نبقي المستند إذا فشل حذف الصورة، لتنجح إعادة المحاولة.
            await _storageService.deleteFile(storagePath: path);
          }

          await document.reference.delete();
        }
      }

      await reference.delete();
    }, timeout: null);
  }

  Future<String> _uploadImage({
    required ExamQuestionImageFile image,
    required String examId,
    required String questionId,
    required String storagePath,
  }) async {
    if (image.bytes.isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }

    await _storageService.uploadData(
      data: image.bytes,
      storagePath: storagePath,
      contentType: _getImageContentType(image.name),
      customMetadata: {
        StorageMetadataFields.examId: examId,
        StorageMetadataFields.questionId: questionId,
        StorageMetadataFields.originalFileName: image.name,
      },
    );

    return _storageService.getDownloadUrl(storagePath: storagePath);
  }

  Future<void> _deleteImageBestEffort(String path) async {
    if (path.trim().isEmpty) {
      return;
    }

    try {
      await _storageService.deleteFile(storagePath: path);
    } catch (error, stackTrace) {
      // فشل تنظيف Storage لا يحوّل تعديلًا محفوظًا إلى فشل ظاهري.
      developer.log(
        'Storage cleanup required: $path',
        name: 'FirebaseExamsRemoteDataSource',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _validateExam({
    required ExamModel exam,
    required List<ExamQuestionModel> questions,
    required Map<String, ExamQuestionImageFile> questionImages,
  }) {
    if (exam.gradeId.trim().isEmpty ||
        exam.examName.trim().isEmpty ||
        exam.durationMinutes <= 0 ||
        questions.isEmpty ||
        questions.length > _maxQuestionsPerExam ||
        exam.status == ExamStatus.ended ||
        exam.questionCount != questions.length) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }

    final Set<String> questionIds = {};
    int totalScore = 0;

    for (final question in questions) {
      _validateQuestion(question);

      if (!questionIds.add(question.questionId)) {
        FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
      }

      totalScore += question.degree;

      // إنشاء امتحان جديد يتوقع صورًا محلية، لا روابط من امتحان آخر.
      if (question.hasImage &&
          !questionImages.containsKey(question.questionId)) {
        FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
      }
    }

    if (totalScore != exam.totalScore ||
        questionImages.keys.any((id) => !questionIds.contains(id))) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }

    for (final image in questionImages.values) {
      if (image.bytes.isEmpty) {
        FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
      }

      _getFileExtension(image.name);
    }
  }

  void _validateQuestion(ExamQuestionModel question) {
    _requireId(question.questionId);

    if (question.questionText.trim().isEmpty ||
        question.degree <= 0 ||
        question.choices.length != 4 ||
        question.choices.any((choice) => choice.trim().isEmpty) ||
        !question.hasCorrectChoice) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }

  String _requireId(String value) {
    final String id = value.trim();

    if (id.isEmpty || id.contains('/')) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }

    return id;
  }

  Map<String, dynamic> _requireData(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    if (!document.exists || data == null) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    return data;
  }

  void _ensureNotDeleting(Map<String, dynamic> data) {
    if (data[_isDeletingField] == true) {
      FirebaseErrorHandler.throwFirestoreCode('failed-precondition');
    }
  }

  void _ensureQuestionsEditable(Map<String, dynamic> data) {
    _ensureNotDeleting(data);

    if (data[FirestoreFields.firstAttemptAt] != null ||
        ExamModel.statusFromJson(data[FirestoreFields.examStatus]) ==
            ExamStatus.ended) {
      FirebaseErrorHandler.throwFirestoreCode('failed-precondition');
    }
  }

  void _ensureQuestionBelongsToExam(Map<String, dynamic> data, String examId) {
    if (data[FirestoreFields.examId] != examId) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }

  FirestoreQueryBuilder _getExamsQuery({String? gradeId, ExamStatus? status}) {
    return (collection) {
      Query<Map<String, dynamic>> query = collection;
      final String normalizedGradeId = gradeId?.trim() ?? '';

      if (normalizedGradeId.isNotEmpty) {
        query = query.where(
          FirestoreFields.gradeId,
          isEqualTo: normalizedGradeId,
        );
      }

      if (status != null) {
        query = query.where(
          FirestoreFields.examStatus,
          isEqualTo: ExamModel.statusToJson(status),
        );
      }

      return query;
    };
  }

  List<ExamModel> _mapExams(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final exams = snapshot.docs.map(ExamModel.fromFirestore).toList();

    exams.sort(_compareExams);

    return List<ExamModel>.unmodifiable(exams);
  }

  int _compareExams(ExamModel first, ExamModel second) {
    final firstDate = first.updatedAt ?? first.createdAt;
    final secondDate = second.updatedAt ?? second.createdAt;

    if (firstDate == null && secondDate == null) {
      return first.examId.compareTo(second.examId);
    }

    if (firstDate == null) return 1;
    if (secondDate == null) return -1;

    final int comparison = secondDate.compareTo(firstDate);

    return comparison != 0 ? comparison : first.examId.compareTo(second.examId);
  }

  int _compareQuestions(ExamQuestionModel first, ExamQuestionModel second) {
    final firstDate = first.createdAt ?? first.updatedAt;
    final secondDate = second.createdAt ?? second.updatedAt;

    if (firstDate == null && secondDate == null) {
      return first.questionId.compareTo(second.questionId);
    }

    if (firstDate == null) return 1;
    if (secondDate == null) return -1;

    final int comparison = firstDate.compareTo(secondDate);

    return comparison != 0
        ? comparison
        : first.questionId.compareTo(second.questionId);
  }

  String _newImagePath({
    required String examId,
    required String questionId,
    required String imageName,
  }) {
    final String extension = _getFileExtension(imageName);
    final String version = _questions.doc().id;

    return '${StorageFolders.examQuestionImages}/'
        '$examId/$questionId/$version.$extension';
  }

  String _getFileExtension(String fileName) {
    final String name = fileName.trim().toLowerCase();
    final int dotIndex = name.lastIndexOf('.');

    if (dotIndex < 0 || dotIndex == name.length - 1) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }

    final String extension = name.substring(dotIndex + 1);

    return switch (extension) {
      'jpeg' => 'jpg',
      'jpg' || 'png' || 'webp' => extension,
      _ => FirebaseErrorHandler.throwFirestoreCode('invalid-argument'),
    };
  }

  String _getImageContentType(String fileName) {
    return switch (_getFileExtension(fileName)) {
      'png' => StorageContentTypes.png,
      'webp' => StorageContentTypes.webp,
      _ => StorageContentTypes.jpeg,
    };
  }

  @override
  Future<ExamQuestionModel> createQuestion({
    required String examId,
    required ExamQuestionModel question,
    ExamQuestionImageFile? image,
  }) {
    return FirebaseErrorHandler.execute(() async {
      final String normalizedExamId = _requireId(examId);

      _validateQuestion(question);

      final DocumentReference<Map<String, dynamic>> examReference = _exams.doc(
        normalizedExamId,
      );

      final DocumentReference<Map<String, dynamic>> questionReference =
          _questions.doc();

      final DocumentSnapshot<Map<String, dynamic>> initialExamSnapshot =
          await examReference.get(const GetOptions(source: Source.server));

      final Map<String, dynamic> initialExamData = _requireData(
        initialExamSnapshot,
      );

      _ensureQuestionsEditable(initialExamData);

      final ExamModel initialExam = ExamModel.fromFirestore(
        initialExamSnapshot,
      );

      if (initialExam.questionCount >= _maxQuestionsPerExam) {
        FirebaseErrorHandler.throwFirestoreCode('failed-precondition');
      }

      String? imageUrl;
      String? imageStoragePath;

      try {
        if (image != null) {
          imageStoragePath = _newImagePath(
            examId: normalizedExamId,
            questionId: questionReference.id,
            imageName: image.name,
          );

          imageUrl = await _uploadImage(
            image: image,
            examId: normalizedExamId,
            questionId: questionReference.id,
            storagePath: imageStoragePath,
          );
        }

        final ExamQuestionModel questionToCreate = ExamQuestionModel(
          questionId: questionReference.id,
          examId: normalizedExamId,
          questionText: question.questionText.trim(),
          degree: question.degree,
          choices: List<String>.unmodifiable(
            question.choices.map((String choice) => choice.trim()),
          ),
          correctChoiceIndex: question.correctChoiceIndex,
          imageUrl: imageUrl,
          imageStoragePath: imageStoragePath,
        );

        await _firestore.runTransaction<void>((Transaction transaction) async {
          final DocumentSnapshot<Map<String, dynamic>> examSnapshot =
              await transaction.get(examReference);

          final Map<String, dynamic> examData = _requireData(examSnapshot);

          _ensureQuestionsEditable(examData);

          final ExamModel currentExam = ExamModel.fromFirestore(examSnapshot);

          if (currentExam.questionCount >= _maxQuestionsPerExam) {
            FirebaseErrorHandler.throwFirestoreCode('failed-precondition');
          }

          transaction.set(questionReference, questionToCreate.toCreateMap());

          transaction.update(examReference, <String, dynamic>{
            FirestoreFields.questionCount: currentExam.questionCount + 1,
            FirestoreFields.totalScore:
                currentExam.totalScore + questionToCreate.degree,
            FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
          });
        });

        return questionToCreate;
      } catch (error, stackTrace) {
        final String? uploadedImagePath = imageStoragePath;

        if (uploadedImagePath != null) {
          await _deleteImageBestEffort(uploadedImagePath);
        }

        Error.throwWithStackTrace(error, stackTrace);
      }
    }, timeout: null);
  }
}
