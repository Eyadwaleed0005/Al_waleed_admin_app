import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/app_loading_indicator.dart';
import 'package:alwaleed_admain/core/widgets/app_toast.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/add_lesson_pdf_picker_cubit.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/add_lesson_pdf_picker_state.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddLessonPdfPicker extends StatelessWidget {
  const AddLessonPdfPicker({
    super.key,
    required this.onFileSelected,
    required this.onFileRemoved,
  });

  final ValueChanged<PlatformFile> onFileSelected;
  final VoidCallback onFileRemoved;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddLessonPdfPickerCubit, AddLessonPdfPickerState>(
      listenWhen: (previous, current) {
        return previous.selectedFile != current.selectedFile ||
            previous.errorMessage != current.errorMessage;
      },
      listener: (context, state) {
        final cubit = context.read<AddLessonPdfPickerCubit>();

        if (state.hasFailure) {
          showAppToast(
            context,
            message: state.errorMessage!,
            icon: Icons.error_outline_rounded,
          );

          cubit.consumeFailure();
          return;
        }

        final file = state.selectedFile;

        if (file != null) {
          onFileSelected(file);
        } else {
          onFileRemoved();
        }
      },
      builder: (context, state) {
        final cubit = context.read<AddLessonPdfPickerCubit>();

        if (state.isPicking) {
          return const _PdfPickerLoading();
        }

        final selectedFile = state.selectedFile;

        if (selectedFile == null) {
          return _EmptyPdfPicker(onTap: cubit.pickPdfFile);
        }

        return _SelectedPdfPicker(
          file: selectedFile,
          fileSize: _formatFileSize(selectedFile.size),
          onTap: cubit.pickPdfFile,
          onRemove: cubit.removeSelectedFile,
        );
      },
    );
  }

  String _formatFileSize(int sizeInBytes) {
    final sizeInKilobytes = sizeInBytes / 1024;
    final sizeInMegabytes = sizeInKilobytes / 1024;

    if (sizeInMegabytes >= 1) {
      return '${sizeInMegabytes.toStringAsFixed(1)} MB';
    }

    return '${sizeInKilobytes.toStringAsFixed(0)} KB';
  }
}

class _EmptyPdfPicker extends StatelessWidget {
  const _EmptyPdfPicker({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'اختيار ملف PDF للدرس',
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'اختر ملف PDF الخاص بالدرس',
                      style: AppTextStyle.font14TextPrimaryRegularTajawal(),
                    ),
                    verticalSpace(12),
                    Text(
                      'الحد الأقصى 15MB',
                      style: AppTextStyle.font12TextMutedRegularTajawal(),
                    ),
                  ],
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
    return Container(
      width: double.infinity,
      height: 116.h,
      decoration: BoxDecoration(
        color: ColorPalette.primarySoftBackground,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: ColorPalette.border, width: 1.2.w),
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
                child: Padding(
                  padding: EdgeInsets.fromLTRB(48.w, 18.h, 48.w, 18.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        file.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.font14TextPrimaryRegularTajawal(),
                      ),
                      verticalSpace(12),
                      Text(
                        'الملف الحالي · اضغط للاستبدال',
                        style: AppTextStyle.font12TextMutedRegularTajawal(),
                      ),
                      verticalSpace(4),
                      Text(
                        fileSize,
                        style: AppTextStyle.font12TextSecondaryRegularTajawal(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8.h,
              left: 8.w,
              child: IconButton(
                tooltip: 'إزالة الملف',
                onPressed: onRemove,
                icon: Icon(
                  Icons.close_rounded,
                  size: 20.sp,
                  color: ColorPalette.textSecondary,
                ),
              ),
            ),
          ],
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
      width: double.infinity,
      height: 116.h,
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: ColorPalette.border),
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
