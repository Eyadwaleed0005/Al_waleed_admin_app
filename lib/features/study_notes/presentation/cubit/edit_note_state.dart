import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/study_notes/domain/entities/study_note_entity.dart';

enum EditNotePageStatus { initial, loading, ready, failure }

enum EditNoteActionStatus {
  idle,
  updating,
  updateSuccess,
  updateFailure,
  deleting,
  deleteSuccess,
  deleteFailure,
}

class EditNotePdfFile {
  const EditNotePdfFile({
    required this.name,
    required this.path,
    required this.sizeInBytes,
  });

  final String name;
  final String path;
  final int sizeInBytes;
}

class EditNoteState {
  const EditNoteState({
    this.pageStatus = EditNotePageStatus.initial,
    this.actionStatus = EditNoteActionStatus.idle,
    this.note,
    this.grades = const [],
    this.title = '',
    this.description = '',
    this.selectedGradeId = '',
    this.isPublished = false,
    this.replacementPdf,
    this.pageError,
    this.actionError,
  });

  final EditNotePageStatus pageStatus;
  final EditNoteActionStatus actionStatus;

  final StudyNoteEntity? note;
  final List<GradeEntity> grades;

  final String title;
  final String description;
  final String selectedGradeId;
  final bool isPublished;

  final EditNotePdfFile? replacementPdf;

  final AppErrorModel? pageError;
  final AppErrorModel? actionError;

  bool get isInitial {
    return pageStatus == EditNotePageStatus.initial;
  }

  bool get isPageLoading {
    return pageStatus == EditNotePageStatus.loading;
  }

  bool get isPageReady {
    return pageStatus == EditNotePageStatus.ready;
  }

  bool get hasPageFailure {
    return pageStatus == EditNotePageStatus.failure;
  }

  bool get isUpdating {
    return actionStatus == EditNoteActionStatus.updating;
  }

  bool get updateSucceeded {
    return actionStatus == EditNoteActionStatus.updateSuccess;
  }

  bool get updateFailed {
    return actionStatus == EditNoteActionStatus.updateFailure;
  }

  bool get isDeleting {
    return actionStatus == EditNoteActionStatus.deleting;
  }

  bool get deleteSucceeded {
    return actionStatus == EditNoteActionStatus.deleteSuccess;
  }

  bool get deleteFailed {
    return actionStatus == EditNoteActionStatus.deleteFailure;
  }

  bool get isActionInProgress {
    return isUpdating || isDeleting;
  }

  bool get hasReplacementPdf {
    return replacementPdf != null;
  }

  bool get hasCurrentPdf {
    final currentNote = note;

    if (hasReplacementPdf) {
      return true;
    }

    if (currentNote == null) {
      return false;
    }

    return currentNote.pdfStoragePath.trim().isNotEmpty &&
        currentNote.pdfFileName.trim().isNotEmpty;
  }

  String get displayedPdfFileName {
    final selectedPdf = replacementPdf;

    if (selectedPdf != null) {
      return selectedPdf.name;
    }

    return note?.pdfFileName ?? '';
  }

  int get displayedPdfFileSize {
    return replacementPdf?.sizeInBytes ?? note?.pdfFileSize ?? 0;
  }

  bool get hasChanges {
    final currentNote = note;

    if (currentNote == null) {
      return false;
    }

    return title.trim() != currentNote.name.trim() ||
        description.trim() != currentNote.description.trim() ||
        selectedGradeId.trim() != currentNote.gradeId.trim() ||
        isPublished != currentNote.isPublished ||
        replacementPdf != null;
  }

  bool get isFormValid {
    return title.trim().isNotEmpty &&
        description.trim().isNotEmpty &&
        selectedGradeId.trim().isNotEmpty &&
        hasCurrentPdf;
  }

  bool get canUpdate {
    return isPageReady && isFormValid && hasChanges && !isActionInProgress;
  }

  bool get canDelete {
    return isPageReady && note != null && !isActionInProgress;
  }

  EditNoteState copyWith({
    EditNotePageStatus? pageStatus,
    EditNoteActionStatus? actionStatus,
    StudyNoteEntity? note,
    List<GradeEntity>? grades,
    String? title,
    String? description,
    String? selectedGradeId,
    bool? isPublished,
    EditNotePdfFile? replacementPdf,
    bool clearReplacementPdf = false,
    AppErrorModel? pageError,
    bool clearPageError = false,
    AppErrorModel? actionError,
    bool clearActionError = false,
  }) {
    return EditNoteState(
      pageStatus: pageStatus ?? this.pageStatus,
      actionStatus: actionStatus ?? this.actionStatus,
      note: note ?? this.note,
      grades: grades ?? this.grades,
      title: title ?? this.title,
      description: description ?? this.description,
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
