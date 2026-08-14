import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';

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

  bool get hasCurrentPdf {
    if (replacementPdf != null) {
      return true;
    }

    final currentLesson = lesson;

    if (currentLesson == null) {
      return false;
    }

    final storagePath = currentLesson.pdfStoragePath?.trim() ?? '';

    final fileName = currentLesson.pdfFileName?.trim() ?? '';

    return storagePath.isNotEmpty && fileName.isNotEmpty;
  }

  String get displayedPdfFileName {
    return replacementPdf?.name ?? lesson?.pdfFileName ?? '';
  }

  int get displayedPdfFileSize {
    return replacementPdf?.sizeInBytes ?? lesson?.pdfFileSize ?? 0;
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
    final gradeValidationError = AppValidator.grade(selectedGradeId);

    if (gradeValidationError != null) {
      return false;
    }

    return grades.any((grade) => grade.gradeId == selectedGradeId.trim());
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
        replacementPdf != null;
  }

  bool get isFormValid {
    return hasValidTitle &&
        hasValidSubtitle &&
        hasValidYoutubeUrl &&
        hasValidSelectedGrade &&
        hasCurrentPdf;
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
      pageError: clearPageError ? null : pageError ?? this.pageError,
      actionError: clearActionError ? null : actionError ?? this.actionError,
    );
  }
}
