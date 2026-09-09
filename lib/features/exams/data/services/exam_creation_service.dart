import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/features/exams/data/models/exam_model.dart';
import 'package:alwaleed_admain/features/exams/data/models/exam_question_model.dart';
import 'package:alwaleed_admain/features/exams/data/services/exam_firestore_guard_service.dart';
import 'package:alwaleed_admain/features/exams/data/services/exam_question_image_service.dart';
import 'package:alwaleed_admain/features/exams/data/validation/exams_data_validator.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamCreationService {
  const ExamCreationService({
    required this._firebaseFirestore,
    required this._examsDataValidator,
    required this._examFirestoreGuardService,
    required this._examQuestionImageService,
  });

  final FirebaseFirestore _firebaseFirestore;
  final ExamsDataValidator _examsDataValidator;
  final ExamFirestoreGuardService _examFirestoreGuardService;
  final ExamQuestionImageService _examQuestionImageService;

  CollectionReference<Map<String, dynamic>> get _exams {
    return _firebaseFirestore.collection(FirestoreCollections.exams);
  }

  CollectionReference<Map<String, dynamic>> get _questions {
    return _firebaseFirestore.collection(FirestoreCollections.examQuestions);
  }

  Future<String> createExam({
    required ExamModel exam,
    required List<ExamQuestionModel> questions,
    required Map<String, ExamQuestionImageFile> questionImages,
  }) async {
    _examsDataValidator.validateCreateExam(
      exam: exam,
      questions: questions,
      questionImages: questionImages,
    );

    final DocumentReference<Map<String, dynamic>> examReference = _exams.doc();

    final WriteBatch batch = _firebaseFirestore.batch();

    final List<String> uploadedImagePaths = <String>[];

    bool commitStarted = false;
    bool preserveUploadedImages = false;

    try {
      for (int index = 0; index < questions.length; index++) {
        final ExamQuestionModel question = questions[index];

        final String questionId =
            '${examReference.id}_${index.toString().padLeft(4, '0')}';

        final DocumentReference<Map<String, dynamic>> questionReference =
            _questions.doc(questionId);

        final ExamQuestionImageFile? image = _findQuestionImage(
          questionImages: questionImages,
          questionId: question.questionId,
        );

        String? imageUrl;
        String? imageStoragePath;

        if (image != null) {
          final ExamQuestionImageUploadResult uploadResult =
              await _examQuestionImageService.uploadImage(
                image: image,
                examId: examReference.id,
                questionId: questionId,
              );

          imageUrl = uploadResult.downloadUrl;
          imageStoragePath = uploadResult.storagePath;

          uploadedImagePaths.add(imageStoragePath);
        }

        final ExamQuestionModel questionToCreate = ExamQuestionModel(
          questionId: questionId,
          examId: examReference.id,
          questionText: question.questionText.trim(),
          degree: question.degree,
          choices: List<String>.unmodifiable(
            question.choices.map((String choice) => choice.trim()),
          ),
          correctChoiceIndex: question.correctChoiceIndex,
          imageUrl: imageUrl,
          imageStoragePath: imageStoragePath,
        );

        batch.set(questionReference, questionToCreate.toCreateMap());
      }

      batch.set(examReference, <String, dynamic>{
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
        FirestoreFields.isDeleting: false,
      });

      commitStarted = true;

      await batch.commit();

      return examReference.id;
    } catch (error, stackTrace) {
      if (commitStarted) {
        final bool? examCreated = await _verifyExamCreated(
          examReference: examReference,
        );

        if (examCreated == true) {
          return examReference.id;
        }

        if (examCreated == null) {
          preserveUploadedImages = true;
        }
      }

      if (!preserveUploadedImages) {
        await _examQuestionImageService.deleteImagesSilently(
          storagePaths: uploadedImagePaths,
        );
      }

      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<ExamQuestionModel> createQuestion({
    required String examId,
    required ExamQuestionModel question,
    ExamQuestionImageFile? image,
  }) async {
    _examsDataValidator.validateCreateQuestion(
      examId: examId,
      question: question,
      image: image,
    );

    final String normalizedExamId = _examsDataValidator.validateId(examId);

    final DocumentReference<Map<String, dynamic>> examReference = _exams.doc(
      normalizedExamId,
    );

    final DocumentReference<Map<String, dynamic>> questionReference = _questions
        .doc();

    final DocumentSnapshot<Map<String, dynamic>> initialExamSnapshot =
        await examReference.get(const GetOptions(source: Source.server));

    final ExamModel initialExam = _examFirestoreGuardService
        .requireQuestionsEditableExam(initialExamSnapshot);

    _examFirestoreGuardService.ensureQuestionsLimitNotReached(
      exam: initialExam,
      maximumQuestions: ExamsDataValidator.maxQuestionsPerExam,
    );

    ExamQuestionImageUploadResult? uploadResult;

    if (image != null) {
      uploadResult = await _examQuestionImageService.uploadImage(
        image: image,
        examId: normalizedExamId,
        questionId: questionReference.id,
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
      imageUrl: uploadResult?.downloadUrl,
      imageStoragePath: uploadResult?.storagePath,
    );

    bool transactionStarted = false;
    bool preserveUploadedImage = false;

    try {
      transactionStarted = true;

      await _firebaseFirestore.runTransaction<void>((
        Transaction transaction,
      ) async {
        final DocumentSnapshot<Map<String, dynamic>> examSnapshot =
            await transaction.get(examReference);

        final ExamModel currentExam = _examFirestoreGuardService
            .requireQuestionsEditableExam(examSnapshot);

        _examFirestoreGuardService.ensureQuestionsLimitNotReached(
          exam: currentExam,
          maximumQuestions: ExamsDataValidator.maxQuestionsPerExam,
        );

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
      if (transactionStarted) {
        final ExamQuestionModel? createdQuestion = await _verifyQuestionCreated(
          questionReference: questionReference,
        );

        if (createdQuestion != null) {
          return createdQuestion;
        }

        final bool? questionExists = await _verifyQuestionExists(
          questionReference: questionReference,
        );

        if (questionExists == null) {
          preserveUploadedImage = true;
        }
      }

      if (!preserveUploadedImage) {
        await _examQuestionImageService.deleteImageSilently(
          storagePath: uploadResult?.storagePath,
        );
      }

      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  ExamQuestionImageFile? _findQuestionImage({
    required Map<String, ExamQuestionImageFile> questionImages,
    required String questionId,
  }) {
    final String normalizedQuestionId = questionId.trim();

    for (final MapEntry<String, ExamQuestionImageFile> entry
        in questionImages.entries) {
      if (entry.key.trim() == normalizedQuestionId) {
        return entry.value;
      }
    }

    return null;
  }

  Future<bool?> _verifyExamCreated({
    required DocumentReference<Map<String, dynamic>> examReference,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await examReference.get(const GetOptions(source: Source.server));

      return snapshot.exists && snapshot.data() != null;
    } catch (_) {
      return null;
    }
  }

  Future<ExamQuestionModel?> _verifyQuestionCreated({
    required DocumentReference<Map<String, dynamic>> questionReference,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await questionReference.get(const GetOptions(source: Source.server));

      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return ExamQuestionModel.fromFirestore(snapshot);
    } catch (_) {
      return null;
    }
  }

  Future<bool?> _verifyQuestionExists({
    required DocumentReference<Map<String, dynamic>> questionReference,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await questionReference.get(const GetOptions(source: Source.server));

      return snapshot.exists && snapshot.data() != null;
    } catch (_) {
      return null;
    }
  }
}
