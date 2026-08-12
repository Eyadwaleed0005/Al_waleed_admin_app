import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/app_loading_indicator.dart';
import 'package:alwaleed_admain/core/widgets/app_toast.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNotePdfPicker extends StatefulWidget {
  const AddNotePdfPicker({
    super.key,
    this.initialFile,
    this.onFileSelected,
    this.onFileRemoved,
  });

  final PlatformFile? initialFile;
  final ValueChanged<PlatformFile>? onFileSelected;
  final VoidCallback? onFileRemoved;

  @override
  State<AddNotePdfPicker> createState() {
    return _AddNotePdfPickerState();
  }
}

class _AddNotePdfPickerState extends State<AddNotePdfPicker> {
  static const int _maximumFileSizeInBytes = 25 * 1024 * 1024;

  PlatformFile? _selectedFile;
  bool _isPickingFile = false;

  @override
  void initState() {
    super.initState();

    _selectedFile = widget.initialFile;
  }

  @override
  void didUpdateWidget(covariant AddNotePdfPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialFile != widget.initialFile) {
      _selectedFile = widget.initialFile;
    }
  }

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
          message: 'حجم الملف أكبر من الحد الأقصى 25MB',
          icon: Icons.error_outline_rounded,
        );

        return;
      }

      setState(() {
        _selectedFile = selectedFile;
      });

      widget.onFileSelected?.call(selectedFile);
    } catch (error) {
      if (!mounted) {
        return;
      }

      showAppToast(
        context,
        message: 'تعذر اختيار الملف، حاول مرة أخرى',
        icon: Icons.error_outline_rounded,
      );

      debugPrint('PDF picker error: $error');
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

  void _removeSelectedFile() {
    if (_isPickingFile) {
      return;
    }

    setState(() {
      _selectedFile = null;
    });

    widget.onFileRemoved?.call();
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
    final selectedFile = _selectedFile;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: _isPickingFile
          ? const _PdfPickerLoading()
          : selectedFile == null
          ? _EmptyPdfPicker(onTap: _pickPdfFile)
          : _SelectedPdfPicker(
              file: selectedFile,
              fileSize: _formatFileSize(selectedFile.size),
              onTap: _pickPdfFile,
              onRemove: _removeSelectedFile,
            ),
    );
  }
}

class _EmptyPdfPicker extends StatelessWidget {
  const _EmptyPdfPicker({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: const ValueKey('empty-pdf-picker'),
      button: true,
      label: 'اختيار ملف PDF من الجهاز',
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
                        'اختر ملف PDF من جهازك',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.font14TextPrimaryRegularTajawal(),
                      ),
                      verticalSpace(12),
                      Text(
                        'الحد الأقصى 25MB',
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

class _SelectedPdfPicker extends StatelessWidget {
  const _SelectedPdfPicker({
    required this.file,
    required this.fileSize,
    required this.onTap,
    required this.onRemove,
  });

  final PlatformFile file;
  final String fileSize;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: ValueKey('selected-pdf-${file.name}'),
      button: true,
      label: 'ملف PDF محدد، اضغط لاستبداله',
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
                          file.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: AppTextStyle.font14TextPrimaryRegularTajawal(),
                        ),
                        verticalSpace(14),
                        Text(
                          'الملف الحالي · اضغط للاستبدال',
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
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Tooltip(
                  message: 'إزالة الملف',
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

class _PdfPickerLoading extends StatelessWidget {
  const _PdfPickerLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('pdf-picker-loading'),
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
