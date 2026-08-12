import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';

enum AddNotePageStatus {
  initial,
  loading,
  ready,
  failure,
}

enum AddNoteSubmissionStatus {
  idle,
  loading,
  success,
  failure,
}

class AddNotePdfFile {
  const AddNotePdfFile({
    required this.name,
    required this.path,
    required this.sizeInBytes,
  });

  final String name;
  final String path;
  final int sizeInBytes;
}

class AddNoteState {
  const AddNoteState({
    this.pageStatus = AddNotePageStatus.initial,
    this.submissionStatus = AddNoteSubmissionStatus.idle,
    this.grades = const [],
    this.title = '',
    this.description = '',
    this.selectedGradeId = '',
    this.isPublished = false,
    this.selectedPdf,
    this.error,
  });

  final AddNotePageStatus pageStatus;
  final AddNoteSubmissionStatus submissionStatus;

  final List<GradeEntity> grades;

  final String title;
  final String description;
  final String selectedGradeId;
  final bool isPublished;

  final AddNotePdfFile? selectedPdf;
  final AppErrorModel? error;

  bool get isPageLoading {
    return pageStatus == AddNotePageStatus.initial ||
        pageStatus == AddNotePageStatus.loading;
  }

  bool get isPageReady {
    return pageStatus == AddNotePageStatus.ready;
  }

  bool get hasPageFailure {
    return pageStatus == AddNotePageStatus.failure;
  }

  bool get isSubmitting {
    return submissionStatus == AddNoteSubmissionStatus.loading;
  }

  bool get submissionSucceeded {
    return submissionStatus == AddNoteSubmissionStatus.success;
  }

  bool get submissionFailed {
    return submissionStatus == AddNoteSubmissionStatus.failure;
  }

  bool get hasTitle {
    return title.trim().isNotEmpty;
  }

  bool get hasDescription {
    return description.trim().isNotEmpty;
  }

  bool get hasSelectedGrade {
    return selectedGradeId.trim().isNotEmpty;
  }

  bool get hasSelectedPdf {
    return selectedPdf != null;
  }

  bool get canSubmit {
    return isPageReady &&
        hasTitle &&
        hasDescription &&
        hasSelectedGrade &&
        hasSelectedPdf &&
        !isSubmitting;
  }

  AddNoteState copyWith({
    AddNotePageStatus? pageStatus,
    AddNoteSubmissionStatus? submissionStatus,
    List<GradeEntity>? grades,
    String? title,
    String? description,
    String? selectedGradeId,
    bool? isPublished,
    AddNotePdfFile? selectedPdf,
    bool clearSelectedPdf = false,
    AppErrorModel? error,
    bool clearError = false,
  }) {
    return AddNoteState(
      pageStatus: pageStatus ?? this.pageStatus,
      submissionStatus:
          submissionStatus ?? this.submissionStatus,
      grades: grades ?? this.grades,
      title: title ?? this.title,
      description: description ?? this.description,
      selectedGradeId:
          selectedGradeId ?? this.selectedGradeId,
      isPublished: isPublished ?? this.isPublished,
      selectedPdf: clearSelectedPdf
          ? null
          : selectedPdf ?? this.selectedPdf,
      error: clearError ? null : error ?? this.error,
    );
  }
}