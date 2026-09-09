import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_draft_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/create_exam_question_use_case.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/create_exam_use_case.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/delete_exam_question_use_case.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/get_exam_by_id_use_case.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/update_exam_question_use_case.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/exam_questions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamQuestionsCubit extends Cubit<ExamQuestionsState> {
  ExamQuestionsCubit({
    required GetExamByIdUseCase getExamByIdUseCase,
    required CreateExamUseCase createExamUseCase,
    required CreateExamQuestionUseCase createExamQuestionUseCase,
    required UpdateExamQuestionUseCase updateExamQuestionUseCase,
    required DeleteExamQuestionUseCase deleteExamQuestionUseCase,
    this.examId,
    this.examDraft,
  }) : _getExamByIdUseCase = getExamByIdUseCase,
       _createExamUseCase = createExamUseCase,
       _createExamQuestionUseCase = createExamQuestionUseCase,
       _updateExamQuestionUseCase = updateExamQuestionUseCase,
       _deleteExamQuestionUseCase = deleteExamQuestionUseCase,
       super(const ExamQuestionsLoading());

  final GetExamByIdUseCase _getExamByIdUseCase;
  final CreateExamUseCase _createExamUseCase;
  final CreateExamQuestionUseCase _createExamQuestionUseCase;
  final UpdateExamQuestionUseCase _updateExamQuestionUseCase;
  final DeleteExamQuestionUseCase _deleteExamQuestionUseCase;

  final String? examId;
  final ExamDraftEntity? examDraft;

  final List<ExamQuestionEntity> _questions = [];

  final Map<String, int> _selectedChoiceIndexes = {};

  final Map<String, int?> _originalChoiceIndexes = {};

  final Map<String, ExamQuestionImageFile> _questionImages = {};

  final Set<String> _dirtyQuestionIds = {};

  final Set<String> _newQuestionIds = {};

  ExamEntity? _loadedExam;

  bool _initialized = false;
  bool _isLoadingExam = false;
  bool _isOperating = false;

  String? _savedExamId;

  bool get isCreatingExam {
    return examDraft != null;
  }

  bool get hasUnsavedChanges {
    return _dirtyQuestionIds.isNotEmpty || _newQuestionIds.isNotEmpty;
  }

  ExamDraftEntity? get currentExamDraft {
    final ExamDraftEntity? draft = examDraft;

    if (draft != null) {
      return draft;
    }

    final ExamEntity? exam = _loadedExam;

    if (exam == null || exam.status == ExamStatus.ended) {
      return null;
    }

    return ExamDraftEntity(
      examName: exam.examName,
      gradeId: exam.gradeId,
      durationMinutes: exam.durationMinutes,
      status: exam.status,
    );
  }

  bool get _canEditQuestions {
    if (isCreatingExam) {
      return _savedExamId == null;
    }

    final ExamEntity? exam = _loadedExam;

    if (exam == null) {
      return false;
    }

    return !exam.isEnded;
  }

  bool get _canModify {
    return !isClosed && !_isLoadingExam && !_isOperating && _canEditQuestions;
  }

  List<ExamQuestionEntity> get questions {
    return List<ExamQuestionEntity>.unmodifiable(_questions);
  }

  Map<String, int> get selectedChoiceIndexes {
    return Map<String, int>.unmodifiable(_selectedChoiceIndexes);
  }

  Map<String, ExamQuestionImageFile> get questionImages {
    return Map<String, ExamQuestionImageFile>.unmodifiable(_questionImages);
  }

  Future<void> initialize() async {
    if (isClosed || _initialized) {
      return;
    }

    _initialized = true;

    if (isCreatingExam) {
      _emitCurrentState();
      return;
    }

    await _loadSavedExam();
  }

  Future<void> retry() async {
    if (isClosed || _isOperating || _isLoadingExam) {
      return;
    }

    if (isCreatingExam) {
      _emitCurrentState();
      return;
    }

    await _loadSavedExam();
  }

  Future<void> _loadSavedExam() async {
    if (isClosed || _isLoadingExam || _isOperating) {
      return;
    }

    final String normalizedExamId = examId?.trim() ?? '';

    if (normalizedExamId.isEmpty) {
      emit(const ExamQuestionsEmpty());
      return;
    }

    _isLoadingExam = true;

    emit(const ExamQuestionsLoading());

    try {
      final result = await _getExamByIdUseCase(examId: normalizedExamId);

      if (isClosed) {
        return;
      }

      result.fold(
        (AppErrorModel error) {
          emit(ExamQuestionsError(error: error));
        },
        (ExamEntity exam) {
          _loadedExam = exam;

          _questions
            ..clear()
            ..addAll(exam.questions);

          _selectedChoiceIndexes.clear();
          _originalChoiceIndexes.clear();
          _questionImages.clear();
          _dirtyQuestionIds.clear();
          _newQuestionIds.clear();

          for (final ExamQuestionEntity question in _questions) {
            _syncCorrectChoice(question);

            _originalChoiceIndexes[question.questionId] =
                question.correctChoiceIndex;
          }

          _emitCurrentState();
        },
      );
    } catch (error) {
      if (!isClosed) {
        emit(ExamQuestionsError(error: FirebaseErrorHandler.handle(error)));
      }
    } finally {
      _isLoadingExam = false;
    }
  }

  void addQuestion({
    required ExamQuestionEntity question,
    ExamQuestionImageFile? image,
  }) {
    if (!_canModify) {
      return;
    }

    final String questionId = question.questionId.trim();

    if (questionId.isEmpty) {
      return;
    }

    final bool alreadyExists = _questions.any((ExamQuestionEntity item) {
      return item.questionId == questionId;
    });

    if (alreadyExists) {
      return;
    }

    final ExamQuestionEntity normalizedQuestion = question.copyWith(
      questionId: questionId,
      choices: List<String>.unmodifiable(question.choices),
    );

    _questions.add(normalizedQuestion);

    if (image != null) {
      _questionImages[questionId] = image;
    }

    _syncCorrectChoice(normalizedQuestion);

    if (!isCreatingExam) {
      _newQuestionIds.add(questionId);
    }

    _emitCurrentState();
  }

  Future<void> updateQuestion({
    required ExamQuestionEntity question,
    ExamQuestionImageFile? image,
    bool removeCurrentImage = false,
  }) async {
    if (!_canModify) {
      return;
    }

    final String questionId = question.questionId.trim();

    final int questionIndex = _questions.indexWhere((ExamQuestionEntity item) {
      return item.questionId == questionId;
    });

    if (questionId.isEmpty || questionIndex == -1) {
      return;
    }

    final ExamQuestionEntity normalizedQuestion = question.copyWith(
      questionId: questionId,
      choices: List<String>.unmodifiable(question.choices),
    );

    final bool isLocalQuestion =
        isCreatingExam || _newQuestionIds.contains(questionId);

    if (isLocalQuestion) {
      _updateLocalQuestion(
        question: normalizedQuestion,
        image: image,
        removeCurrentImage: removeCurrentImage,
      );

      return;
    }

    await _updateSavedQuestion(
      question: normalizedQuestion,
      image: image,
      removeCurrentImage: removeCurrentImage,
    );
  }

  Future<void> _updateSavedQuestion({
    required ExamQuestionEntity question,
    required ExamQuestionImageFile? image,
    required bool removeCurrentImage,
  }) async {
    _isOperating = true;

    _emitCurrentState(
      operation: ExamQuestionsOperation.updateQuestion,
      operatingQuestionId: question.questionId,
    );

    try {
      final result = await _updateExamQuestionUseCase(
        question: question,
        newImage: image,
        removeCurrentImage: removeCurrentImage,
      );

      if (isClosed) {
        return;
      }

      _isOperating = false;

      result.fold(
        (AppErrorModel error) {
          _emitCurrentState(
            operation: ExamQuestionsOperation.updateQuestion,
            operationError: error,
            operatingQuestionId: question.questionId,
          );
        },
        (_) {
          _updateLocalQuestion(
            question: question,
            image: image,
            removeCurrentImage: removeCurrentImage,
            emitState: false,
          );

          _originalChoiceIndexes[question.questionId] =
              question.correctChoiceIndex;

          _dirtyQuestionIds.remove(question.questionId);

          _emitCurrentState(
            operation: ExamQuestionsOperation.updateQuestion,
            operationSucceeded: true,
            operatingQuestionId: question.questionId,
          );
        },
      );
    } catch (error) {
      _isOperating = false;

      if (!isClosed) {
        _emitCurrentState(
          operation: ExamQuestionsOperation.updateQuestion,
          operationError: FirebaseErrorHandler.handle(error),
          operatingQuestionId: question.questionId,
        );
      }
    } finally {
      _isOperating = false;
    }
  }

  void _updateLocalQuestion({
    required ExamQuestionEntity question,
    required ExamQuestionImageFile? image,
    required bool removeCurrentImage,
    bool emitState = true,
  }) {
    final int questionIndex = _questions.indexWhere((ExamQuestionEntity item) {
      return item.questionId == question.questionId;
    });

    if (questionIndex == -1) {
      return;
    }

    _questions[questionIndex] = question;

    if (removeCurrentImage) {
      _questionImages.remove(question.questionId);
    } else if (image != null) {
      _questionImages[question.questionId] = image;
    }

    _syncCorrectChoice(question);

    if (emitState) {
      _emitCurrentState();
    }
  }

  Future<void> deleteQuestion({required String questionId}) async {
    if (!_canModify) {
      return;
    }

    final String normalizedQuestionId = questionId.trim();

    if (normalizedQuestionId.isEmpty) {
      return;
    }

    final bool questionExists = _questions.any((ExamQuestionEntity question) {
      return question.questionId == normalizedQuestionId;
    });

    if (!questionExists) {
      return;
    }

    final bool isLocalQuestion =
        isCreatingExam || _newQuestionIds.contains(normalizedQuestionId);

    if (isLocalQuestion) {
      _removeLocalQuestion(normalizedQuestionId);
      _emitCurrentState();
      return;
    }

    final String normalizedExamId =
        _loadedExam?.examId.trim() ?? examId?.trim() ?? '';

    if (normalizedExamId.isEmpty) {
      return;
    }

    _isOperating = true;

    _emitCurrentState(
      operation: ExamQuestionsOperation.deleteQuestion,
      operatingQuestionId: normalizedQuestionId,
    );

    try {
      final result = await _deleteExamQuestionUseCase(
        examId: normalizedExamId,
        questionId: normalizedQuestionId,
      );

      if (isClosed) {
        return;
      }

      _isOperating = false;

      result.fold(
        (AppErrorModel error) {
          _emitCurrentState(
            operation: ExamQuestionsOperation.deleteQuestion,
            operationError: error,
            operatingQuestionId: normalizedQuestionId,
          );
        },
        (_) {
          _removeLocalQuestion(normalizedQuestionId);

          _emitCurrentState(
            operation: ExamQuestionsOperation.deleteQuestion,
            operationSucceeded: true,
            operatingQuestionId: normalizedQuestionId,
          );
        },
      );
    } catch (error) {
      _isOperating = false;

      if (!isClosed) {
        _emitCurrentState(
          operation: ExamQuestionsOperation.deleteQuestion,
          operationError: FirebaseErrorHandler.handle(error),
          operatingQuestionId: normalizedQuestionId,
        );
      }
    } finally {
      _isOperating = false;
    }
  }

  void _removeLocalQuestion(String questionId) {
    _questions.removeWhere((ExamQuestionEntity question) {
      return question.questionId == questionId;
    });

    _selectedChoiceIndexes.remove(questionId);
    _originalChoiceIndexes.remove(questionId);
    _questionImages.remove(questionId);
    _dirtyQuestionIds.remove(questionId);
    _newQuestionIds.remove(questionId);
  }

  void selectCorrectChoice({
    required String questionId,
    required int choiceIndex,
  }) {
    if (!_canModify) {
      return;
    }

    final String normalizedQuestionId = questionId.trim();

    final int questionIndex = _questions.indexWhere((
      ExamQuestionEntity question,
    ) {
      return question.questionId == normalizedQuestionId;
    });

    if (questionIndex == -1) {
      return;
    }

    final ExamQuestionEntity currentQuestion = _questions[questionIndex];

    if (choiceIndex < 0 ||
        choiceIndex >= currentQuestion.choices.length ||
        currentQuestion.correctChoiceIndex == choiceIndex) {
      return;
    }

    final ExamQuestionEntity updatedQuestion = currentQuestion.copyWith(
      correctChoiceIndex: choiceIndex,
    );

    _questions[questionIndex] = updatedQuestion;

    _selectedChoiceIndexes[normalizedQuestionId] = choiceIndex;

    final bool isNewQuestion = _newQuestionIds.contains(normalizedQuestionId);

    if (!isCreatingExam && !isNewQuestion) {
      final int? originalChoiceIndex =
          _originalChoiceIndexes[normalizedQuestionId];

      if (choiceIndex == originalChoiceIndex) {
        _dirtyQuestionIds.remove(normalizedQuestionId);
      } else {
        _dirtyQuestionIds.add(normalizedQuestionId);
      }
    }

    _emitCurrentState();
  }

  Future<void> saveChanges() async {
    if (isCreatingExam) {
      await saveExam();
      return;
    }

    await saveQuestionChanges();
  }

  Future<void> saveQuestionChanges() async {
    if (!_canModify || isCreatingExam || !hasUnsavedChanges) {
      return;
    }

    final ExamQuestionsState currentState = state;

    if (currentState is! ExamQuestionsSuccess ||
        !currentState.allQuestionsHaveCorrectChoice) {
      return;
    }

    final String normalizedExamId =
        _loadedExam?.examId.trim() ?? examId?.trim() ?? '';

    if (normalizedExamId.isEmpty) {
      return;
    }

    _isOperating = true;

    _emitCurrentState(operation: ExamQuestionsOperation.saveQuestionChanges);

    try {
      final List<String> newQuestionIds = List<String>.from(_newQuestionIds);

      for (final String temporaryQuestionId in newQuestionIds) {
        final int questionIndex = _questions.indexWhere((
          ExamQuestionEntity question,
        ) {
          return question.questionId == temporaryQuestionId;
        });

        if (questionIndex == -1) {
          _newQuestionIds.remove(temporaryQuestionId);
          continue;
        }

        final ExamQuestionEntity question = _questions[questionIndex];

        final ExamQuestionImageFile? image =
            _questionImages[temporaryQuestionId];

        final result = await _createExamQuestionUseCase(
          examId: normalizedExamId,
          question: question,
          image: image,
        );

        if (isClosed) {
          return;
        }

        final AppErrorModel? createError = result.fold<AppErrorModel?>(
          (AppErrorModel error) => error,
          (_) => null,
        );

        if (createError != null) {
          _isOperating = false;

          _emitCurrentState(
            operation: ExamQuestionsOperation.saveQuestionChanges,
            operationError: createError,
          );

          return;
        }

        final ExamQuestionEntity createdQuestion = result.getOrElse(
          () => question,
        );

        _replaceTemporaryQuestion(
          temporaryQuestionId: temporaryQuestionId,
          createdQuestion: createdQuestion,
          image: image,
        );
      }

      final List<String> dirtyQuestionIds = List<String>.from(
        _dirtyQuestionIds,
      );

      for (final String questionId in dirtyQuestionIds) {
        final int questionIndex = _questions.indexWhere((
          ExamQuestionEntity question,
        ) {
          return question.questionId == questionId;
        });

        if (questionIndex == -1) {
          _dirtyQuestionIds.remove(questionId);
          continue;
        }

        final ExamQuestionEntity question = _questions[questionIndex];

        final result = await _updateExamQuestionUseCase(
          question: question,
          newImage: null,
          removeCurrentImage: false,
        );

        if (isClosed) {
          return;
        }

        final AppErrorModel? updateError = result.fold<AppErrorModel?>(
          (AppErrorModel error) => error,
          (_) => null,
        );

        if (updateError != null) {
          _isOperating = false;

          _emitCurrentState(
            operation: ExamQuestionsOperation.saveQuestionChanges,
            operationError: updateError,
          );

          return;
        }

        _originalChoiceIndexes[questionId] = question.correctChoiceIndex;

        _dirtyQuestionIds.remove(questionId);
      }

      _isOperating = false;

      _emitCurrentState(
        operation: ExamQuestionsOperation.saveQuestionChanges,
        operationSucceeded: true,
      );
    } catch (error) {
      _isOperating = false;

      if (!isClosed) {
        _emitCurrentState(
          operation: ExamQuestionsOperation.saveQuestionChanges,
          operationError: FirebaseErrorHandler.handle(error),
        );
      }
    } finally {
      _isOperating = false;
    }
  }

  void _replaceTemporaryQuestion({
    required String temporaryQuestionId,
    required ExamQuestionEntity createdQuestion,
    required ExamQuestionImageFile? image,
  }) {
    final int questionIndex = _questions.indexWhere((
      ExamQuestionEntity question,
    ) {
      return question.questionId == temporaryQuestionId;
    });

    if (questionIndex == -1) {
      return;
    }

    _questions[questionIndex] = createdQuestion;

    final int? selectedChoiceIndex = _selectedChoiceIndexes.remove(
      temporaryQuestionId,
    );

    if (selectedChoiceIndex != null) {
      _selectedChoiceIndexes[createdQuestion.questionId] = selectedChoiceIndex;
    }

    _questionImages.remove(temporaryQuestionId);

    if (image != null) {
      _questionImages[createdQuestion.questionId] = image;
    }

    _newQuestionIds.remove(temporaryQuestionId);
    _dirtyQuestionIds.remove(temporaryQuestionId);
    _originalChoiceIndexes.remove(temporaryQuestionId);

    _originalChoiceIndexes[createdQuestion.questionId] =
        createdQuestion.correctChoiceIndex;
  }

  Future<void> saveExam() async {
    if (!_canModify || !isCreatingExam) {
      return;
    }

    final ExamDraftEntity? draft = examDraft;
    final ExamQuestionsState currentState = state;

    if (draft == null ||
        currentState is! ExamQuestionsSuccess ||
        !currentState.canSaveExam) {
      return;
    }

    final List<ExamQuestionEntity> questionsToSave =
        List<ExamQuestionEntity>.unmodifiable(
          _questions.map((ExamQuestionEntity question) {
            return question.copyWith(
              correctChoiceIndex: _selectedChoiceIndexes[question.questionId],
              choices: List<String>.unmodifiable(question.choices),
            );
          }),
        );

    final Map<String, ExamQuestionImageFile> imagesToSave =
        Map<String, ExamQuestionImageFile>.unmodifiable(_questionImages);

    _isOperating = true;

    _emitCurrentState(operation: ExamQuestionsOperation.createExam);

    try {
      final result = await _createExamUseCase(
        examDraft: draft,
        questions: questionsToSave,
        questionImages: imagesToSave,
      );

      if (isClosed) {
        return;
      }

      _isOperating = false;

      result.fold(
        (AppErrorModel error) {
          _emitCurrentState(
            operation: ExamQuestionsOperation.createExam,
            operationError: error,
          );
        },
        (String createdExamId) {
          _savedExamId = createdExamId;

          _emitCurrentState(
            operation: ExamQuestionsOperation.createExam,
            operationSucceeded: true,
          );
        },
      );
    } catch (error) {
      _isOperating = false;

      if (!isClosed) {
        _emitCurrentState(
          operation: ExamQuestionsOperation.createExam,
          operationError: FirebaseErrorHandler.handle(error),
        );
      }
    } finally {
      _isOperating = false;
    }
  }

  void clearOperationResult() {
    if (isClosed || _isOperating) {
      return;
    }

    _emitCurrentState();
  }

  void _syncCorrectChoice(ExamQuestionEntity question) {
    final int? correctChoiceIndex = question.correctChoiceIndex;

    final bool isValid =
        correctChoiceIndex != null &&
        correctChoiceIndex >= 0 &&
        correctChoiceIndex < question.choices.length;

    if (!isValid) {
      _selectedChoiceIndexes.remove(question.questionId);

      return;
    }

    _selectedChoiceIndexes[question.questionId] = correctChoiceIndex;
  }

  void _emitCurrentState({
    ExamQuestionsOperation? operation,
    bool operationSucceeded = false,
    AppErrorModel? operationError,
    String? operatingQuestionId,
  }) {
    if (isClosed) {
      return;
    }

    final bool hasOperationResult =
        operation != null && (operationSucceeded || operationError != null);

    if (_questions.isEmpty &&
        isCreatingExam &&
        !_isOperating &&
        !hasOperationResult) {
      emit(const ExamQuestionsEmpty());
      return;
    }

    emit(
      ExamQuestionsSuccess(
        questions: _questions,
        selectedChoiceIndexes: _selectedChoiceIndexes,
        questionImages: _questionImages,
        isCreatingExam: isCreatingExam,
        canEdit: _canEditQuestions,
        hasUnsavedChanges: hasUnsavedChanges,
        isOperating: _isOperating,
        operation: operation,
        operationSucceeded: operationSucceeded,
        operationError: operationError,
        operatingQuestionId: operatingQuestionId,
        savedExamId: _savedExamId,
      ),
    );
  }
}
