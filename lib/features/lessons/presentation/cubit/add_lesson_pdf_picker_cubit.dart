import 'package:alwaleed_admain/features/lessons/presentation/cubit/add_lesson_pdf_picker_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLessonPdfPickerCubit
    extends Cubit<AddLessonPdfPickerState> {
  AddLessonPdfPickerCubit()
    : super(const AddLessonPdfPickerState());

  static const int maximumFileSizeInBytes =
      15 * 1024 * 1024;

  Future<void> pickPdfFile() async {
    if (state.isPicking) return;

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

      if (isClosed) return;

      if (selectedFile == null) {
        _emitCurrentStatus();
        return;
      }

      if (!_isPdfFile(selectedFile)) {
        _emitFailure('يجب اختيار ملف PDF فقط');
        return;
      }

      if (selectedFile.size >
          maximumFileSizeInBytes) {
        _emitFailure(
          'حجم الملف أكبر من الحد الأقصى 15MB',
        );
        return;
      }

      final path = selectedFile.path?.trim();

      if (path == null || path.isEmpty) {
        _emitFailure(
          'تعذر الوصول إلى مسار الملف المحدد',
        );
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
      if (isClosed) return;

      _emitFailure(
        'تعذر اختيار الملف، حاول مرة أخرى',
      );
    }
  }

  void removeSelectedFile() {
    if (state.isPicking) return;

    emit(
      state.copyWith(
        status: AddLessonPdfPickerStatus.initial,
        clearSelectedFile: true,
        clearError: true,
      ),
    );
  }

  void consumeFailure() {
    if (!state.hasFailure) return;

    _emitCurrentStatus();
  }

  void _emitCurrentStatus() {
    emit(
      state.copyWith(
        status: state.selectedFile == null
            ? AddLessonPdfPickerStatus.initial
            : AddLessonPdfPickerStatus.selected,
        clearError: true,
      ),
    );
  }

  void _emitFailure(String message) {
    emit(
      state.copyWith(
        status: AddLessonPdfPickerStatus.failure,
        errorMessage: message,
      ),
    );
  }

  bool _isPdfFile(PlatformFile file) {
    final extension =
        file.extension?.trim().toLowerCase();

    return extension == 'pdf' ||
        file.name.trim().toLowerCase().endsWith(
          '.pdf',
        );
  }
}