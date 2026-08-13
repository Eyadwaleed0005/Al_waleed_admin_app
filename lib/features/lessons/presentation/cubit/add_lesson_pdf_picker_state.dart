import 'package:file_picker/file_picker.dart';

enum AddLessonPdfPickerStatus {
  initial,
  picking,
  selected,
  failure,
}

class AddLessonPdfPickerState {
  const AddLessonPdfPickerState({
    this.status = AddLessonPdfPickerStatus.initial,
    this.selectedFile,
    this.errorMessage,
  });

  final AddLessonPdfPickerStatus status;
  final PlatformFile? selectedFile;
  final String? errorMessage;

  bool get isPicking {
    return status == AddLessonPdfPickerStatus.picking;
  }

  bool get hasSelectedFile {
    return selectedFile != null;
  }

  bool get hasFailure {
    return status == AddLessonPdfPickerStatus.failure &&
        errorMessage != null;
  }

  AddLessonPdfPickerState copyWith({
    AddLessonPdfPickerStatus? status,
    PlatformFile? selectedFile,
    bool clearSelectedFile = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddLessonPdfPickerState(
      status: status ?? this.status,
      selectedFile: clearSelectedFile
          ? null
          : selectedFile ?? this.selectedFile,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}