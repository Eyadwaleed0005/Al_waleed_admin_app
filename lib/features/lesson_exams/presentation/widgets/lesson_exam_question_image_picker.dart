import 'package:alwaleed_admain/core/helper/app_image_compression_helper.dart';
import 'package:alwaleed_admain/core/helper/app_image_validator.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/app_loading_indicator.dart';
import 'package:alwaleed_admain/core/widgets/app_toast.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/lesson_exam_question_image_file.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonExamQuestionImagePicker extends StatefulWidget {
  const LessonExamQuestionImagePicker({
    super.key,
    required this.selectedImage,
    required this.onImageSelected,
    required this.onImageRemoved,
    this.currentImageUrl,
    this.isCurrentImageRemoved = false,
    this.isEnabled = true,
  });

  final LessonExamQuestionImageFile? selectedImage;
  final String? currentImageUrl;

  final bool isCurrentImageRemoved;

  final ValueChanged<LessonExamQuestionImageFile> onImageSelected;

  final VoidCallback onImageRemoved;

  final bool isEnabled;

  @override
  State<LessonExamQuestionImagePicker> createState() {
    return _LessonExamQuestionImagePickerState();
  }
}

class _LessonExamQuestionImagePickerState
    extends State<LessonExamQuestionImagePicker> {
  bool _isPickingImage = false;

  Future<void> _pickImage() async {
    if (_isPickingImage || !widget.isEnabled) {
      return;
    }

    setState(() {
      _isPickingImage = true;
    });

    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: AppImageValidator.allowedExtensions,
        allowMultiple: false,
        withData: true,
      );

      if (!mounted || result == null) {
        return;
      }

      final files = result.files;

      if (files.isEmpty) {
        return;
      }

      final selectedFile = files.first;

      final validationMessage = AppImageValidator.validatePickedImage(
        fileName: selectedFile.name,
        extension: selectedFile.extension,
        sizeInBytes: selectedFile.size,
        bytes: selectedFile.bytes,
      );

      if (validationMessage != null) {
        showAppToast(
          context,
          message: validationMessage,
          icon: Icons.error_outline_rounded,
        );

        return;
      }

      final originalBytes = selectedFile.bytes!;

      final compressionResult =
          await AppImageCompressionHelper.compressForFirebase(
            bytes: originalBytes,
            originalFileName: selectedFile.name,
          );

      final compressedValidationMessage =
          AppImageValidator.validateCompressedImage(compressionResult.bytes);

      if (compressedValidationMessage != null) {
        showAppToast(
          context,
          message: compressedValidationMessage,
          icon: Icons.error_outline_rounded,
        );

        return;
      }

      final originalPath = selectedFile.path?.trim();

      widget.onImageSelected(
        LessonExamQuestionImageFile(
          name: compressionResult.fileName,
          sizeInBytes: compressionResult.sizeInBytes,
          bytes: compressionResult.bytes,
          path: compressionResult.wasCompressed
              ? null
              : originalPath == null || originalPath.isEmpty
              ? null
              : originalPath,
        ),
      );
    } on AppImageCompressionException catch (error) {
      if (!mounted) {
        return;
      }

      showAppToast(
        context,
        message: error.message,
        icon: Icons.error_outline_rounded,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      showAppToast(
        context,
        message: 'تعذر اختيار أو ضغط الصورة، حاول مرة أخرى',
        icon: Icons.error_outline_rounded,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
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
    final selectedImage = widget.selectedImage;

    final normalizedCurrentImageUrl = widget.currentImageUrl?.trim();

    final hasCurrentImage =
        normalizedCurrentImageUrl != null &&
        normalizedCurrentImageUrl.isNotEmpty &&
        !widget.isCurrentImageRemoved;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: _isPickingImage
          ? const _QuestionImagePickerLoading()
          : selectedImage != null
          ? _SelectedQuestionImagePicker(
              key: ValueKey<String>('selected-${selectedImage.name}'),
              image: selectedImage,
              formattedFileSize: _formatFileSize(selectedImage.sizeInBytes),
              onTap: _pickImage,
              onRemove: widget.onImageRemoved,
              isEnabled: widget.isEnabled,
            )
          : hasCurrentImage
          ? _CurrentQuestionImagePicker(
              key: ValueKey<String>('current-$normalizedCurrentImageUrl'),
              imageUrl: normalizedCurrentImageUrl,
              onTap: _pickImage,
              onRemove: widget.onImageRemoved,
              isEnabled: widget.isEnabled,
            )
          : _EmptyQuestionImagePicker(
              key: const ValueKey<String>('empty-question-image-picker'),
              onTap: _pickImage,
              isEnabled: widget.isEnabled,
            ),
    );
  }
}

class _EmptyQuestionImagePicker extends StatelessWidget {
  const _EmptyQuestionImagePicker({
    super.key,
    required this.onTap,
    required this.isEnabled,
  });

  final VoidCallback onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: isEnabled,
      label: 'اختيار صورة للسؤال من الجهاز',
      child: Opacity(
        opacity: isEnabled ? 1 : 0.55,
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
                  onTap: isEnabled ? onTap : null,
                  borderRadius: BorderRadius.circular(22.r),
                  splashColor: ColorPalette.primarySoftBackground,
                  highlightColor: ColorPalette.primarySoftBackground,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 14.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: ColorPalette.primary,
                          size: 28.sp,
                        ),

                        verticalSpace(8),

                        Text(
                          'اختر صورة للسؤال من جهازك',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.font14TextPrimaryRegularTajawal(),
                        ),

                        verticalSpace(5),

                        Text(
                          'اختياري · JPG أو PNG أو WEBP · حتى '
                          '${AppImageValidator.maximumPickedImageSizeInMegabytes}MB',
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
      ),
    );
  }
}

class _SelectedQuestionImagePicker extends StatelessWidget {
  const _SelectedQuestionImagePicker({
    super.key,
    required this.image,
    required this.formattedFileSize,
    required this.onTap,
    required this.onRemove,
    required this.isEnabled,
  });

  final LessonExamQuestionImageFile image;

  final String formattedFileSize;

  final VoidCallback onTap;

  final VoidCallback onRemove;

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: isEnabled,
      label: 'تم اختيار صورة للسؤال، اضغط لاستبدالها',
      child: Opacity(
        opacity: isEnabled ? 1 : 0.55,
        child: Container(
          width: double.infinity,
          height: 136.h,
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
                    onTap: isEnabled ? onTap : null,
                    borderRadius: BorderRadius.circular(22.r),
                    splashColor: ColorPalette.infoSoftBg,
                    highlightColor: ColorPalette.infoSoftBg,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(44.w, 14.h, 14.w, 14.h),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14.r),
                            child: Image.memory(
                              image.bytes,
                              width: 96.w,
                              height: 108.h,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                            ),
                          ),

                          horizontalSpace(14),

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  image.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style:
                                      AppTextStyle.font14TextPrimaryRegularTajawal(),
                                ),

                                verticalSpace(8),

                                Text(
                                  'الصورة جاهزة · اضغط للاستبدال',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style:
                                      AppTextStyle.font12TextMutedRegularTajawal(),
                                ),

                                verticalSpace(4),

                                Text(
                                  formattedFileSize,
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style:
                                      AppTextStyle.font12TextSecondaryRegularTajawal(),
                                ),
                              ],
                            ),
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
                    message: 'حذف الصورة',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isEnabled ? onRemove : null,
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
      ),
    );
  }
}

class _CurrentQuestionImagePicker extends StatelessWidget {
  const _CurrentQuestionImagePicker({
    super.key,
    required this.imageUrl,
    required this.onTap,
    required this.onRemove,
    required this.isEnabled,
  });

  final String imageUrl;

  final VoidCallback onTap;

  final VoidCallback onRemove;

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: isEnabled,
      label: 'الصورة الحالية للسؤال، اضغط لاستبدالها',
      child: Opacity(
        opacity: isEnabled ? 1 : 0.55,
        child: Container(
          width: double.infinity,
          height: 136.h,
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
                    onTap: isEnabled ? onTap : null,
                    borderRadius: BorderRadius.circular(22.r),
                    splashColor: ColorPalette.infoSoftBg,
                    highlightColor: ColorPalette.infoSoftBg,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(44.w, 14.h, 14.w, 14.h),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14.r),
                            child: Image.network(
                              imageUrl,
                              width: 96.w,
                              height: 108.h,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }

                                    return Container(
                                      width: 96.w,
                                      height: 108.h,
                                      color: ColorPalette.surface,
                                      alignment: Alignment.center,
                                      child: AppLoadingIndicator(
                                        color: ColorPalette.primary,
                                        size: 24.sp,
                                        strokeWidth: 2.w,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 96.w,
                                  height: 108.h,
                                  color: ColorPalette.surface,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    size: 30.sp,
                                    color: ColorPalette.textSecondary,
                                  ),
                                );
                              },
                            ),
                          ),

                          horizontalSpace(14),

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'الصورة الحالية',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style:
                                      AppTextStyle.font14TextPrimaryRegularTajawal(),
                                ),

                                verticalSpace(8),

                                Text(
                                  'اضغط على الصورة لاستبدالها',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style:
                                      AppTextStyle.font12TextMutedRegularTajawal(),
                                ),
                              ],
                            ),
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
                    message: 'حذف الصورة',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isEnabled ? onRemove : null,
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
      ),
    );
  }
}

class _QuestionImagePickerLoading extends StatelessWidget {
  const _QuestionImagePickerLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('question-image-picker-loading'),
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
