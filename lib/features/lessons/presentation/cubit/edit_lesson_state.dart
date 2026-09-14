import 'package:alwaleed_admin/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admin/core/helper/app_validator.dart';
import 'package:alwaleed_admin/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admin/features/lessons/domain/entities/lesson_entity.dart';

enum EditLessonPageStatus { initial, loading, ready, failure }

enum EditLessonActionStatus {
  idle,
  updating,
  updateSuccess,
  updateFailure,
  deleting,
  deleteSuccess,
  deleteFailure,
}

class EditLessonPdfFile {
  const EditLessonPdfFile({
    required this.name,
    required this.path,
    required this.sizeInBytes,
  });

  final String name;
  final String path;
  final int sizeInBytes;

  bool get isValid {
    return name.trim().isNotEmpty && path.trim().isNotEmpty && sizeInBytes > 0;
  }
}

class EditLessonState {
  const EditLessonState({
    this.pageStatus = EditLessonPageStatus.initial,
    this.actionStatus = EditLessonActionStatus.idle,
    this.lesson,
    this.grades = const [],
    this.title = '',
    this.subtitle = '',
    this.youtubeUrl = '',
    this.selectedGradeId = '',
    this.isPublished = false,
    this.replacementPdf,
    this.shouldRemoveExistingPdf = false,
    this.pageError,
    this.actionError,
  });

  final EditLessonPageStatus pageStatus;
  final EditLessonActionStatus actionStatus;

  final LessonEntity? lesson;
  final List<GradeEntity> grades;

  final String title;
  final String subtitle;
  final String youtubeUrl;
  final String selectedGradeId;

  final bool isPublished;

  final EditLessonPdfFile? replacementPdf;
  final bool shouldRemoveExistingPdf;

  final AppErrorModel? pageError;
  final AppErrorModel? actionError;

  bool get isInitial {
    return pageStatus == EditLessonPageStatus.initial;
  }

  bool get isPageLoading {
    return pageStatus == EditLessonPageStatus.initial ||
        pageStatus == EditLessonPageStatus.loading;
  }

  bool get isPageReady {
    return pageStatus == EditLessonPageStatus.ready;
  }

  bool get hasPageFailure {
    return pageStatus == EditLessonPageStatus.failure;
  }

  bool get isUpdating {
    return actionStatus == EditLessonActionStatus.updating;
  }

  bool get updateSucceeded {
    return actionStatus == EditLessonActionStatus.updateSuccess;
  }

  bool get updateFailed {
    return actionStatus == EditLessonActionStatus.updateFailure;
  }

  bool get isDeleting {
    return actionStatus == EditLessonActionStatus.deleting;
  }

  bool get deleteSucceeded {
    return actionStatus == EditLessonActionStatus.deleteSuccess;
  }

  bool get deleteFailed {
    return actionStatus == EditLessonActionStatus.deleteFailure;
  }

  bool get isActionInProgress {
    return isUpdating || isDeleting;
  }

  bool get isActionIdle {
    return actionStatus == EditLessonActionStatus.idle;
  }

  bool get hasReplacementPdf {
    return replacementPdf != null;
  }

  bool get hasExistingPdf {
    final currentLesson = lesson;

    if (currentLesson == null) {
      return false;
    }

    final storagePath = currentLesson.pdfStoragePath?.trim() ?? '';

    final fileName = currentLesson.pdfFileName?.trim() ?? '';

    final fileSize = currentLesson.pdfFileSize ?? 0;

    return storagePath.isNotEmpty && fileName.isNotEmpty && fileSize > 0;
  }

  bool get hasCurrentPdf {
    if (replacementPdf != null) {
      return true;
    }

    if (shouldRemoveExistingPdf) {
      return false;
    }

    return hasExistingPdf;
  }

  String get displayedPdfFileName {
    final replacement = replacementPdf;

    if (replacement != null) {
      return replacement.name;
    }

    if (shouldRemoveExistingPdf) {
      return '';
    }

    return lesson?.pdfFileName?.trim() ?? '';
  }

  int get displayedPdfFileSize {
    final replacement = replacementPdf;

    if (replacement != null) {
      return replacement.sizeInBytes;
    }

    if (shouldRemoveExistingPdf) {
      return 0;
    }

    return lesson?.pdfFileSize ?? 0;
  }

  bool get hasValidTitle {
    return AppValidator.lessonTitle(title) == null;
  }

  bool get hasValidSubtitle {
    return AppValidator.lessonSubtitle(subtitle) == null;
  }

  bool get hasValidYoutubeUrl {
    return AppValidator.youtubeUrl(youtubeUrl) == null;
  }

  bool get hasValidSelectedGrade {
    final normalizedGradeId = selectedGradeId.trim();

    final validationError = AppValidator.grade(normalizedGradeId);

    if (validationError != null) {
      return false;
    }

    return grades.any((grade) {
      return grade.gradeId == normalizedGradeId;
    });
  }

  bool get hasValidReplacementPdf {
    final file = replacementPdf;

    if (file == null) {
      return true;
    }

    if (!file.isValid) {
      return false;
    }

    return AppValidator.lessonPdfFile(
          fileName: file.name,
          extension: null,
          sizeInBytes: file.sizeInBytes,
          path: file.path,
        ) ==
        null;
  }

  bool get hasChanges {
    final currentLesson = lesson;

    if (currentLesson == null) {
      return false;
    }

    final currentYoutubeUrl = currentLesson.youtubeUrl?.trim() ?? '';

    return title.trim() != currentLesson.title.trim() ||
        subtitle.trim() != currentLesson.subtitle.trim() ||
        youtubeUrl.trim() != currentYoutubeUrl ||
        selectedGradeId.trim() != currentLesson.gradeId.trim() ||
        isPublished != currentLesson.isPublished ||
        replacementPdf != null ||
        shouldRemoveExistingPdf;
  }

  bool get isFormValid {
    return hasValidTitle &&
        hasValidSubtitle &&
        hasValidYoutubeUrl &&
        hasValidSelectedGrade &&
        hasValidReplacementPdf;
  }

  bool get canUpdate {
    return isPageReady && isActionIdle && isFormValid && hasChanges;
  }

  bool get canDelete {
    return isPageReady && isActionIdle && lesson != null;
  }

  EditLessonState copyWith({
    EditLessonPageStatus? pageStatus,
    EditLessonActionStatus? actionStatus,
    LessonEntity? lesson,
    List<GradeEntity>? grades,
    String? title,
    String? subtitle,
    String? youtubeUrl,
    String? selectedGradeId,
    bool? isPublished,
    EditLessonPdfFile? replacementPdf,
    bool clearReplacementPdf = false,
    bool? shouldRemoveExistingPdf,
    AppErrorModel? pageError,
    bool clearPageError = false,
    AppErrorModel? actionError,
    bool clearActionError = false,
  }) {
    return EditLessonState(
      pageStatus: pageStatus ?? this.pageStatus,
      actionStatus: actionStatus ?? this.actionStatus,
      lesson: lesson ?? this.lesson,
      grades: grades ?? this.grades,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      selectedGradeId: selectedGradeId ?? this.selectedGradeId,
      isPublished: isPublished ?? this.isPublished,
      replacementPdf: clearReplacementPdf
          ? null
          : replacementPdf ?? this.replacementPdf,
      shouldRemoveExistingPdf:
          shouldRemoveExistingPdf ?? this.shouldRemoveExistingPdf,
      pageError: clearPageError ? null : pageError ?? this.pageError,
      actionError: clearActionError ? null : actionError ?? this.actionError,
    );
  }
}
