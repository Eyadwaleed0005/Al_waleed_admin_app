import 'package:alwaleed_admin/core/helper/arabic_numbers_helper.dart';
import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/style/textstyles.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamCardViewData {
  const ExamCardViewData({
    required this.examId,
    required this.examName,
    required this.gradeName,
    required this.questionCount,
    required this.totalScore,
    required this.durationMinutes,
    required this.participantsCount,
    required this.status,
    this.closedDateText,
  });

  final String examId;
  final String examName;
  final String gradeName;

  final int questionCount;
  final int totalScore;
  final int durationMinutes;
  final int participantsCount;

  final ExamStatus status;

  final String? closedDateText;
}

class ExamCard extends StatelessWidget {
  const ExamCard({
    super.key,
    required this.exam,
    this.onExamPressed,
    this.onViewResultsPressed,
  });

  final ExamCardViewData exam;

  final VoidCallback? onExamPressed;
  final VoidCallback? onViewResultsPressed;

  @override
  Widget build(BuildContext context) {
    final bool isExamEnded = exam.status == ExamStatus.ended;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onExamPressed,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: ColorPalette.cardBackground,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: ColorPalette.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: ColorPalette.primaryShadow,
                blurRadius: 8.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildExamHeader(),
              verticalSpace(8),
              _buildExamDetails(),
              verticalSpace(12),
              _buildParticipantsBadge(),
              if (isExamEnded) ...[
                verticalSpace(18),
                _buildViewResultsButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamHeader() {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            exam.examName,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.font18TextPrimarySemiBoldKufam().copyWith(
              height: 1.4,
            ),
          ),
        ),
        horizontalSpace(12),
        _ExamStatusBadge(status: exam.status),
      ],
    );
  }

  Widget _buildExamDetails() {
    return Text(
      _examDetailsText,
      textAlign: TextAlign.right,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
        height: 1.5,
      ),
    );
  }

  Widget _buildParticipantsBadge() {
    return Align(
      alignment: Alignment.centerRight,
      child: _ExamParticipantsBadge(participantsCount: exam.participantsCount),
    );
  }

  Widget _buildViewResultsButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton(
        onPressed: onViewResultsPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorPalette.primary,
          side: const BorderSide(color: ColorPalette.primary, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 11.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.r),
          ),
        ),
        child: Text(
          'عرض النتائج',
          style: AppTextStyle.font15PrimaryBoldTajawal(),
        ),
      ),
    );
  }

  String get _examDetailsText {
    return switch (exam.status) {
      ExamStatus.ended => _endedExamDetails,
      ExamStatus.published => _publishedExamDetails,
      ExamStatus.unpublished => _unpublishedExamDetails,
    };
  }

  String get _endedExamDetails {
    final List<String> examDetails = [
      exam.gradeName,
      '${toArabicNumbers(exam.totalScore)} درجة',
    ];

    final String? closedDateText = exam.closedDateText;

    if (closedDateText != null && closedDateText.trim().isNotEmpty) {
      examDetails.add('أُغلق $closedDateText');
    }

    return examDetails.join(' • ');
  }

  String get _publishedExamDetails {
    return [
      exam.gradeName,
      '${toArabicNumbers(exam.questionCount)} سؤال',
      '${toArabicNumbers(exam.durationMinutes)} دقيقة',
    ].join(' • ');
  }

  String get _unpublishedExamDetails {
    return [
      exam.gradeName,
      '${toArabicNumbers(exam.questionCount)} سؤال',
      '${toArabicNumbers(exam.durationMinutes)} دقيقة',
      'لم يُنشر',
    ].join(' • ');
  }
}

class _ExamParticipantsBadge extends StatelessWidget {
  const _ExamParticipantsBadge({required this.participantsCount});

  final int participantsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: ColorPalette.primarySoftBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(
            Icons.people_alt_outlined,
            size: 17.sp,
            color: ColorPalette.primary,
          ),
          horizontalSpace(6),
          Text(
            '${toArabicNumbers(participantsCount)} دخلوا الاختبار',
            style: AppTextStyle.font12PrimaryMediumTajawal().copyWith(
              color: ColorPalette.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamStatusBadge extends StatelessWidget {
  const _ExamStatusBadge({required this.status});

  final ExamStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        _statusText,
        style: AppTextStyle.font12PrimaryMediumTajawal().copyWith(
          color: _textColor,
        ),
      ),
    );
  }

  String get _statusText {
    return switch (status) {
      ExamStatus.ended => 'منتهي',
      ExamStatus.published => 'منشور',
      ExamStatus.unpublished => 'غير منشور',
    };
  }

  Color get _backgroundColor {
    return switch (status) {
      ExamStatus.ended => ColorPalette.error,
      ExamStatus.published => ColorPalette.success,
      ExamStatus.unpublished => ColorPalette.highlightShadow,
    };
  }

  Color get _textColor {
    return switch (status) {
      ExamStatus.ended => ColorPalette.surface,
      ExamStatus.published => ColorPalette.surface,
      ExamStatus.unpublished => ColorPalette.warning,
    };
  }
}
