import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/add_lesson_pdf_picker_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLessonPdfPickerCubit extends Cubit<AddLessonPdfPickerState> {
  AddLessonPdfPickerCubit() : super(const AddLessonPdfPickerState());

  Future<void> pickPdfFile() async {
    if (state.isPicking) {
      return;
    }

    emit(
      state.copyWith(
        status: AddLessonPdfPickerStatus.picking,
        clearError: true,
      ),
    );

    try {
      final selectedFile = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
      );

      if (isClosed) {
        return;
      }

      if (selectedFile == null) {
        _restoreCurrentStatus();
        return;
      }

      final validationError = AppValidator.lessonPdfFile(
        fileName: selectedFile.name,
        extension: selectedFile.extension,
        sizeInBytes: selectedFile.size,
        path: selectedFile.path,
      );

      if (validationError != null) {
        _emitFailure(validationError);
        return;
      }

      emit(
        state.copyWith(
          status: AddLessonPdfPickerStatus.selected,
          selectedFile: selectedFile,
          clearError: true,
        ),
      );
    } catch (_) {
      if (isClosed) {
        return;
      }

      _emitFailure(AppValidator.lessonPdfPickingFailureMessage);
    }
  }

  void removeSelectedFile() {
    if (isClosed || state.isPicking) {
      return;
    }

    emit(
      state.copyWith(
        status: AddLessonPdfPickerStatus.initial,
        clearSelectedFile: true,
        clearError: true,
      ),
    );
  }

  void consumeFailure() {
    if (isClosed || !state.hasFailure) {
      return;
    }

    _restoreCurrentStatus();
  }

  void _restoreCurrentStatus() {
    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        status: state.hasSelectedFile
            ? AddLessonPdfPickerStatus.selected
            : AddLessonPdfPickerStatus.initial,
        clearError: true,
      ),
    );
  }

  void _emitFailure(String message) {
    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        status: AddLessonPdfPickerStatus.failure,
        errorMessage: message,
      ),
    );
  }
}
