import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/app_loading_indicator.dart';
import 'package:alwaleed_admain/core/widgets/app_toast.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/edit_lesson_state.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditLessonPdfPicker extends StatefulWidget {
  const EditLessonPdfPicker({
    super.key,
    required this.existingFileName,
    required this.existingFileSize,
    required this.replacementPdf,
    required this.onReplacementSelected,
    required this.onReplacementRemoved,
  });

  final String existingFileName;
  final int existingFileSize;

  final EditLessonPdfFile? replacementPdf;

  final ValueChanged<EditLessonPdfFile> onReplacementSelected;
  final VoidCallback onReplacementRemoved;

  @override
  State<EditLessonPdfPicker> createState() {
    return _EditLessonPdfPickerState();
  }
}

class _EditLessonPdfPickerState extends State<EditLessonPdfPicker> {
  static const int _maximumFileSizeInBytes = 15 * 1024 * 1024;

  bool _isPickingFile = false;

  Future<void> _pickPdfFile() async {
    if (_isPickingFile) {
      return;
    }

    setState(() {
      _isPickingFile = true;
    });

    try {
      final selectedFile = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
      );

      if (!mounted || selectedFile == null) {
        return;
      }

      if (!_isPdfFile(selectedFile)) {
        showAppToast(
          context,
          message: 'يجب اختيار ملف PDF فقط',
          icon: Icons.error_outline_rounded,
        );

        return;
      }

      if (selectedFile.size > _maximumFileSizeInBytes) {
        showAppToast(
          context,
          message: 'حجم الملف أكبر من الحد الأقصى 15MB',
          icon: Icons.error_outline_rounded,
        );

        return;
      }

      final filePath = selectedFile.path?.trim();

      if (filePath == null || filePath.isEmpty) {
        showAppToast(
          context,
          message: 'تعذر الوصول إلى الملف المحدد، حاول مرة أخرى',
          icon: Icons.error_outline_rounded,
        );

        return;
      }

      widget.onReplacementSelected(
        EditLessonPdfFile(
          name: selectedFile.name.trim(),
          path: filePath,
          sizeInBytes: selectedFile.size,
        ),
      );
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      showAppToast(
        context,
        message: 'تعذر اختيار الملف، حاول مرة أخرى',
        icon: Icons.error_outline_rounded,
      );

      debugPrint('Edit lesson PDF picker error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (mounted) {
        setState(() {
          _isPickingFile = false;
        });
      }
    }
  }

  bool _isPdfFile(PlatformFile file) {
    final extension = file.extension?.trim().toLowerCase();

    if (extension == 'pdf') {
      return true;
    }

    return file.name.trim().toLowerCase().endsWith('.pdf');
  }

  String _formatFileSize(int sizeInBytes) {
    final sizeInKilobytes = sizeInBytes / 1024;
    final sizeInMegabytes = sizeInKilobytes / 1024;

    if (sizeInMegabytes >= 1) {
      return '${sizeInMegabytes.toStringAsFixed(1)} MB';
    }

    return '${sizeInKilobytes.toStringAsFixed(0)} KB';
  }

  @override
  Widget build(BuildContext context) {
    final replacementPdf = widget.replacementPdf;
    final existingFileName = widget.existingFileName.trim();
    final hasExistingFile = existingFileName.isNotEmpty;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: _isPickingFile
          ? const _EditLessonPdfPickerLoading()
          : replacementPdf != null
          ? _EditLessonSelectedPdfPicker(
              key: ValueKey<String>('replacement-${replacementPdf.path}'),
              fileName: replacementPdf.name,
              fileSize: _formatFileSize(replacementPdf.sizeInBytes),
              statusText: 'ملف جديد · اضغط للاستبدال',
              showRemoveButton: true,
              onTap: _pickPdfFile,
              onRemove: widget.onReplacementRemoved,
            )
          : hasExistingFile
          ? _EditLessonSelectedPdfPicker(
              key: ValueKey<String>('existing-$existingFileName'),
              fileName: existingFileName,
              fileSize: _formatFileSize(widget.existingFileSize),
              statusText: 'الملف الحالي · اضغط للاستبدال',
              showRemoveButton: false,
              onTap: _pickPdfFile,
            )
          : _EmptyEditLessonPdfPicker(onTap: _pickPdfFile),
    );
  }
}

class _EmptyEditLessonPdfPicker extends StatelessWidget {
  const _EmptyEditLessonPdfPicker({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: const ValueKey<String>('empty-edit-lesson-pdf-picker'),
      button: true,
      label: 'اختيار ملف PDF للدرس من الجهاز',
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: ColorPalette.black.withValues(alpha: 0.05),
              blurRadius: 8.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(22.r),
            color: ColorPalette.border,
            strokeWidth: 1.5.w,
            dashPattern: [7.w, 5.w],
            padding: EdgeInsets.zero,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 116.h,
            child: Material(
              color: ColorPalette.surface,
              borderRadius: BorderRadius.circular(22.r),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(22.r),
                splashColor: ColorPalette.primarySoftBackground,
                highlightColor: ColorPalette.primarySoftBackground,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 18.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'اختر ملف PDF للدرس من جهازك',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.font14TextPrimaryRegularTajawal(),
                      ),
                      verticalSpace(12),
                      Text(
                        'الحد الأقصى 15MB',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.font12TextMutedRegularTajawal(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditLessonSelectedPdfPicker extends StatelessWidget {
  const _EditLessonSelectedPdfPicker({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.statusText,
    required this.showRemoveButton,
    required this.onTap,
    this.onRemove,
  });

  final String fileName;
  final String fileSize;
  final String statusText;

  final bool showRemoveButton;

  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'ملف PDF للدرس موجود، اضغط لاستبداله',
      child: Container(
        width: double.infinity,
        height: 116.h,
        decoration: BoxDecoration(
          color: ColorPalette.primarySoftBackground,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: ColorPalette.border, width: 1.2.w),
          boxShadow: [
            BoxShadow(
              color: ColorPalette.black.withValues(alpha: 0.06),
              blurRadius: 8.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22.r),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(22.r),
                  splashColor: ColorPalette.infoSoftBg,
                  highlightColor: ColorPalette.infoSoftBg,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(48.w, 18.h, 48.w, 18.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: AppTextStyle.font14TextPrimaryRegularTajawal(),
                        ),
                        verticalSpace(14),
                        Text(
                          statusText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.font12TextMutedRegularTajawal(),
                        ),
                        verticalSpace(4),
                        Text(
                          fileSize,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style:
                              AppTextStyle.font12TextSecondaryRegularTajawal(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (showRemoveButton)
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Tooltip(
                    message: 'إلغاء استبدال الملف',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onRemove,
                        borderRadius: BorderRadius.circular(20.r),
                        splashColor: ColorPalette.error.withValues(alpha: 0.10),
                        highlightColor: ColorPalette.error.withValues(
                          alpha: 0.08,
                        ),
                        child: SizedBox(
                          width: 32.w,
                          height: 32.w,
                          child: Icon(
                            Icons.close_rounded,
                            size: 20.sp,
                            color: ColorPalette.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditLessonPdfPickerLoading extends StatelessWidget {
  const _EditLessonPdfPickerLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('edit-lesson-pdf-picker-loading'),
      width: double.infinity,
      height: 116.h,
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: ColorPalette.border, width: 1.w),
      ),
      alignment: Alignment.center,
      child: AppLoadingIndicator(
        color: ColorPalette.primary,
        size: 28.sp,
        strokeWidth: 2.w,
      ),
    );
  }
}
