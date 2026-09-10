import 'package:alwaleed_admin/core/helper/arabic_numbers_helper.dart';
import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/style/textstyles.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_question_entity.dart';
import 'package:alwaleed_admin/features/exams/domain/exam_question_image_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamQuestionCard extends StatelessWidget {
  const ExamQuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.selectedChoiceIndex,
    required this.onChoiceSelected,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.showActions,
    this.localImage,
    this.isEnabled = true,
    this.isDeleting = false,
  });

  final ExamQuestionEntity question;
  final int questionNumber;
  final int? selectedChoiceIndex;
  final ExamQuestionImageFile? localImage;

  final ValueChanged<int> onChoiceSelected;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  final bool showActions;
  final bool isEnabled;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = question.imageUrl?.trim();

    final bool hasImage =
        localImage != null || (imageUrl != null && imageUrl.isNotEmpty);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isDeleting ? 0.65 : 1,
      child: IgnorePointer(
        ignoring: !isEnabled || isDeleting,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: ColorPalette.surface,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: ColorPalette.border, width: 1.w),
            boxShadow: [
              BoxShadow(
                color: ColorPalette.primary.withValues(alpha: 0.08),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _QuestionCardHeader(
                questionNumber: questionNumber,
                degree: question.degree,
                showActions: showActions,
                isDeleting: isDeleting,
                onEditPressed: onEditPressed,
                onDeletePressed: onDeletePressed,
              ),
              verticalSpace(18),
              Text(
                question.questionText,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: AppTextStyle.font14TextPrimaryMediumKufam().copyWith(
                  height: 1.7,
                ),
              ),
              if (hasImage) ...[
                verticalSpace(16),
                _buildQuestionImage(imageUrl),
              ],
              verticalSpace(16),
              ...List<Widget>.generate(question.choices.length, (
                int choiceIndex,
              ) {
                final bool isSelected = selectedChoiceIndex == choiceIndex;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: choiceIndex == question.choices.length - 1
                        ? 0
                        : 8.h,
                  ),
                  child: _ExamQuestionChoiceTile(
                    choice: question.choices[choiceIndex],
                    isSelected: isSelected,
                    onPressed: () {
                      onChoiceSelected(choiceIndex);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionImage(String? imageUrl) {
    final ExamQuestionImageFile? image = localImage;

    return Container(
      width: double.infinity,
      height: 150.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ColorPalette.secondary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ColorPalette.secondary.withValues(alpha: 0.08),
          width: 1.w,
        ),
      ),
      child: image != null
          ? Image.memory(
              image.bytes,
              fit: BoxFit.contain,
              errorBuilder: _buildImageError,
            )
          : Image.network(
              imageUrl!,
              fit: BoxFit.contain,
              loadingBuilder:
                  (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Center(
                      child: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4.w,
                          color: ColorPalette.primary,
                        ),
                      ),
                    );
                  },
              errorBuilder: _buildImageError,
            ),
    );
  }

  Widget _buildImageError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Center(
      child: Icon(
        Icons.broken_image_outlined,
        size: 38.sp,
        color: ColorPalette.disabled,
      ),
    );
  }
}

class _QuestionCardHeader extends StatelessWidget {
  const _QuestionCardHeader({
    required this.questionNumber,
    required this.degree,
    required this.showActions,
    required this.isDeleting,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final int questionNumber;
  final int degree;

  final bool showActions;
  final bool isDeleting;

  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'السؤال ${toArabicNumbers(questionNumber)}',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTextStyle.font15PrimaryBoldTajawal().copyWith(
                fontSize: 19.sp,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: ColorPalette.highlight,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${toArabicNumbers(degree)} درجة',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: AppTextStyle.font13TextPrimaryRegularTajawal().copyWith(
                  color: ColorPalette.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (showActions)
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QuestionActionText(
                    text: 'تعديل',
                    color: ColorPalette.primary,
                    onPressed: onEditPressed,
                  ),
                  horizontalSpace(12),
                  if (isDeleting)
                    SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        color: ColorPalette.error,
                      ),
                    )
                  else
                    _QuestionActionText(
                      text: 'حذف',
                      color: ColorPalette.error,
                      onPressed: onDeletePressed,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _QuestionActionText extends StatelessWidget {
  const _QuestionActionText({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  final String text;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
          child: Text(
            text,
            style: AppTextStyle.font13TextPrimaryRegularTajawal().copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExamQuestionChoiceTile extends StatelessWidget {
  const _ExamQuestionChoiceTile({
    required this.choice,
    required this.isSelected,
    required this.onPressed,
  });

  final String choice;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? ColorPalette.primary.withValues(alpha: 0.06)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 46.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: Text(
                  choice,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyle.font14TextPrimaryRegularTajawal()
                      .copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                ),
              ),
              horizontalSpace(12),
              _AnswerIndicator(isSelected: isSelected),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerIndicator extends StatelessWidget {
  const _AnswerIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16.w,
      height: 16.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? ColorPalette.primary : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? ColorPalette.primary
              : ColorPalette.primary.withValues(alpha: 0.25),
          width: 1.7.w,
        ),
      ),
      child: isSelected
          ? Container(
              width: 5.w,
              height: 5.h,
              decoration: const BoxDecoration(
                color: ColorPalette.surface,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}
