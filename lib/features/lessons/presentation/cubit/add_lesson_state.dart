import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';

enum AddLessonPageStatus { initial, loading, ready, failure }

enum AddLessonSubmissionStatus { idle, loading, success, failure }

class AddLessonPdfFile {
  const AddLessonPdfFile({
    required this.name,
    required this.path,
    required this.sizeInBytes,
  });

  final String name;
  final String path;
  final int sizeInBytes;
}

class AddLessonState {
  const AddLessonState({
    this.pageStatus = AddLessonPageStatus.initial,
    this.submissionStatus = AddLessonSubmissionStatus.idle,
    this.grades = const [],
    this.title = '',
    this.subtitle = '',
    this.youtubeUrl = '',
    this.selectedGradeId = '',
    this.isPublished = false,
    this.selectedPdf,
    this.error,
  });

  final AddLessonPageStatus pageStatus;

  final AddLessonSubmissionStatus submissionStatus;

  final List<GradeEntity> grades;

  final String title;
  final String subtitle;
  final String youtubeUrl;
  final String selectedGradeId;

  final bool isPublished;

  final AddLessonPdfFile? selectedPdf;
  final AppErrorModel? error;

  bool get isPageLoading {
    return pageStatus == AddLessonPageStatus.initial ||
        pageStatus == AddLessonPageStatus.loading;
  }

  bool get isPageReady {
    return pageStatus == AddLessonPageStatus.ready;
  }

  bool get hasPageFailure {
    return pageStatus == AddLessonPageStatus.failure;
  }

  bool get isSubmitting {
    return submissionStatus == AddLessonSubmissionStatus.loading;
  }

  bool get submissionSucceeded {
    return submissionStatus == AddLessonSubmissionStatus.success;
  }

  bool get submissionFailed {
    return submissionStatus == AddLessonSubmissionStatus.failure;
  }

  bool get hasTitle {
    return title.trim().isNotEmpty;
  }

  bool get hasSubtitle {
    return subtitle.trim().isNotEmpty;
  }

  bool get hasYoutubeUrl {
    return youtubeUrl.trim().isNotEmpty;
  }

  bool get hasValidYoutubeUrl {
    final uri = Uri.tryParse(youtubeUrl.trim());

    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return false;
    }

    final scheme = uri.scheme.toLowerCase();

    if (scheme != 'http' && scheme != 'https') {
      return false;
    }

    final host = uri.host.toLowerCase();

    return host == 'youtu.be' ||
        host == 'youtube.com' ||
        host.endsWith('.youtube.com');
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
        hasSubtitle &&
        hasValidYoutubeUrl &&
        hasSelectedGrade &&
        hasSelectedPdf &&
        !isSubmitting;
  }

  AddLessonState copyWith({
    AddLessonPageStatus? pageStatus,
    AddLessonSubmissionStatus? submissionStatus,
    List<GradeEntity>? grades,
    String? title,
    String? subtitle,
    String? youtubeUrl,
    String? selectedGradeId,
    bool? isPublished,
    AddLessonPdfFile? selectedPdf,
    bool clearSelectedPdf = false,
    AppErrorModel? error,
    bool clearError = false,
  }) {
    return AddLessonState(
      pageStatus: pageStatus ?? this.pageStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      grades: grades ?? this.grades,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      selectedGradeId: selectedGradeId ?? this.selectedGradeId,
      isPublished: isPublished ?? this.isPublished,
      selectedPdf: clearSelectedPdf ? null : selectedPdf ?? this.selectedPdf,
      error: clearError ? null : error ?? this.error,
    );
  }
}
