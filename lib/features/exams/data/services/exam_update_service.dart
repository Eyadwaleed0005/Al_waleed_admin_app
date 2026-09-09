import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/features/exams/data/models/exam_model.dart';
import 'package:alwaleed_admain/features/exams/data/models/exam_question_model.dart';
import 'package:alwaleed_admain/features/exams/data/services/exam_firestore_guard_service.dart';
import 'package:alwaleed_admain/features/exams/data/services/exam_question_image_service.dart';
import 'package:alwaleed_admain/features/exams/data/validation/constants/exam_feature_messages.dart';
import 'package:alwaleed_admain/features/exams/data/validation/exams_data_validator.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamUpdateService {
  const ExamUpdateService({
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
    return _firebaseFirestore.collection(
      FirestoreCollections.exams,
    );
  }

  CollectionReference<Map<String, dynamic>> get _questions {
    return _firebaseFirestore.collection(
      FirestoreCollections.examQuestions,
    );
  }

  Future<void> updateExam({
    required ExamModel exam,
  }) async {
    _examsDataValidator.validateUpdateExam(exam: exam);

    final String examId = _examsDataValidator.validateId(exam.examId);

    final DocumentReference<Map<String, dynamic>> examReference = _exams.doc(
      examId,
    );

    await _firebaseFirestore.runTransaction<void>(
      (Transaction transaction) async {
        final DocumentSnapshot<Map<String, dynamic>> examSnapshot =
            await transaction.get(examReference);

        _examFirestoreGuardService.ensureSettingsCanBeUpdated(
          currentSnapshot: examSnapshot,
          updatedExam: exam,
        );

        final ExamModel currentExam = _examFirestoreGuardService
            .requireAvailableExam(examSnapshot);

        if (exam.status == ExamStatus.published &&
            currentExam.questionCount <= 0) {
          FirebaseErrorHandler.throwFirestoreCode(
            'failed-precondition',
            message: ExamFeatureMessages.publishingRequiresQuestions,
          );
        }

        transaction.update(
          examReference,
          <String, dynamic>{
            FirestoreFields.gradeId: exam.gradeId.trim(),
            FirestoreFields.examName: exam.examName.trim(),
            FirestoreFields.durationMinutes: exam.durationMinutes,
            FirestoreFields.examStatus: ExamModel.statusToJson(
              exam.status,
            ),
            if (exam.status == ExamStatus.ended)
              FirestoreFields.closedAt: FieldValue.serverTimestamp(),
            FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
          },
        );
      },
    );
  }

  Future<void> updateQuestion({
    required ExamQuestionModel question,
    ExamQuestionImageFile? newImage,
    required bool removeCurrentImage,
  }) async {
    _examsDataValidator.validateUpdateQuestion(
      question: question,
      newImage: newImage,
      removeCurrentImage: removeCurrentImage,
    );

    final String examId = _examsDataValidator.validateId(question.examId);

    final String questionId = _examsDataValidator.validateId(
      question.questionId,
    );

    final DocumentReference<Map<String, dynamic>> examReference = _exams.doc(
      examId,
    );

    final DocumentReference<Map<String, dynamic>> questionReference =
        _questions.doc(questionId);

    final DocumentSnapshot<Map<String, dynamic>> initialExamSnapshot =
        await examReference.get(
          const GetOptions(source: Source.server),
        );

    _examFirestoreGuardService.requireQuestionsEditableExam(
      initialExamSnapshot,
    );

    final DocumentSnapshot<Map<String, dynamic>> initialQuestionSnapshot =
        await questionReference.get(
          const GetOptions(source: Source.server),
        );

    final ExamQuestionModel initialQuestion = _examFirestoreGuardService
        .requireExamQuestion(
          initialQuestionSnapshot,
          examId: examId,
        );

    ExamQuestionImageUploadResult? uploadResult;

    if (newImage != null) {
      uploadResult = await _examQuestionImageService.uploadImage(
        image: newImage,
        examId: examId,
        questionId: questionId,
      );
    }

    final bool changesImage = newImage != null || removeCurrentImage;

    final String? updatedImageUrl = newImage != null
        ? uploadResult?.downloadUrl
        : removeCurrentImage
        ? null
        : initialQuestion.imageUrl;

    final String? updatedImageStoragePath = newImage != null
        ? uploadResult?.storagePath
        : removeCurrentImage
        ? null
        : initialQuestion.imageStoragePath;

    try {
      final String? obsoleteImagePath = await _firebaseFirestore
          .runTransaction<String?>(
            (Transaction transaction) async {
              final DocumentSnapshot<Map<String, dynamic>> examSnapshot =
                  await transaction.get(examReference);

              final DocumentSnapshot<Map<String, dynamic>> questionSnapshot =
                  await transaction.get(questionReference);

              final ExamModel currentExam = _examFirestoreGuardService
                  .requireQuestionsEditableExam(examSnapshot);

              final ExamQuestionModel currentQuestion =
                  _examFirestoreGuardService.requireExamQuestion(
                    questionSnapshot,
                    examId: examId,
                  );

              final int updatedTotalScore =
                  currentExam.totalScore -
                  currentQuestion.degree +
                  question.degree;

              if (updatedTotalScore < 0) {
                FirebaseErrorHandler.throwFirestoreCode(
                  'failed-precondition',
                );
              }

              transaction.update(
                questionReference,
                <String, dynamic>{
                  FirestoreFields.questionText: question.questionText.trim(),
                  FirestoreFields.questionScore: question.degree,
                  FirestoreFields.option1: question.choices[0].trim(),
                  FirestoreFields.option2: question.choices[1].trim(),
                  FirestoreFields.option3: question.choices[2].trim(),
                  FirestoreFields.option4: question.choices[3].trim(),
                  FirestoreFields.correctOption:
                      question.correctChoiceIndex,
                  if (changesImage)
                    FirestoreFields.questionImageUrl: updatedImageUrl,
                  if (changesImage)
                    FirestoreFields.questionImageStoragePath:
                        updatedImageStoragePath,
                  FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
                },
              );

              transaction.update(
                examReference,
                <String, dynamic>{
                  FirestoreFields.totalScore: updatedTotalScore,
                  FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
                },
              );

              if (!changesImage) {
                return null;
              }

              return currentQuestion.imageStoragePath;
            },
          );

      if (obsoleteImagePath != null &&
          obsoleteImagePath.trim().isNotEmpty &&
          obsoleteImagePath != updatedImageStoragePath) {
        await _examQuestionImageService.deleteImageSilently(
          storagePath: obsoleteImagePath,
        );
      }
    } catch (error, stackTrace) {
      final bool? updateApplied = await _verifyQuestionUpdate(
        questionReference: questionReference,
        expectedQuestion: question,
        changesImage: changesImage,
        expectedImageStoragePath: updatedImageStoragePath,
      );

      if (updateApplied == true) {
        if (changesImage &&
            initialQuestion.imageStoragePath != updatedImageStoragePath) {
          await _examQuestionImageService.deleteImageSilently(
            storagePath: initialQuestion.imageStoragePath,
          );
        }

        return;
      }

      if (updateApplied == false && uploadResult != null) {
        await _examQuestionImageService.deleteImageSilently(
          storagePath: uploadResult.storagePath,
        );
      }

      Error.throwWithStackTrace(
        error,
        stackTrace,
      );
    }
  }

  Future<bool?> _verifyQuestionUpdate({
    required DocumentReference<Map<String, dynamic>> questionReference,
    required ExamQuestionModel expectedQuestion,
    required bool changesImage,
    required String? expectedImageStoragePath,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await questionReference.get(
            const GetOptions(source: Source.server),
          );

      if (!snapshot.exists || snapshot.data() == null) {
        return false;
      }

      final ExamQuestionModel savedQuestion = ExamQuestionModel.fromFirestore(
        snapshot,
      );

      final bool questionDataMatches =
          savedQuestion.questionText.trim() ==
              expectedQuestion.questionText.trim() &&
          savedQuestion.degree == expectedQuestion.degree &&
          _choicesMatch(
            savedQuestion.choices,
            expectedQuestion.choices,
          ) &&
          savedQuestion.correctChoiceIndex ==
              expectedQuestion.correctChoiceIndex;

      if (!questionDataMatches) {
        return false;
      }

      if (!changesImage) {
        return true;
      }

      return savedQuestion.imageStoragePath?.trim() ==
          expectedImageStoragePath?.trim();
    } catch (_) {
      return null;
    }
  }

  bool _choicesMatch(
    List<String> firstChoices,
    List<String> secondChoices,
  ) {
    if (firstChoices.length != secondChoices.length) {
      return false;
    }

    for (int index = 0; index < firstChoices.length; index++) {
      if (firstChoices[index].trim() != secondChoices[index].trim()) {
        return false;
      }
    }

    return true;
  }
}