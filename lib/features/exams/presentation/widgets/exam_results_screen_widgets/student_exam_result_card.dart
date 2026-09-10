import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum StudentExamResultStatus {
  passed,
  failed,
}

class StudentExamResultViewData {
  const StudentExamResultViewData({
    required this.studentId,
    required this.studentName,
    required this.gradeName,
    required this.studentScoreText,
    required this.totalScoreText,
    required this.status,
  });

  final String studentId;
  final String studentName;
  final String gradeName;
  final String studentScoreText;
  final String totalScoreText;
  final StudentExamResultStatus status;
}

class StudentExamResultCard extends StatelessWidget {
  const StudentExamResultCard({
    super.key,
    required this.studentResult,
  });

  final StudentExamResultViewData studentResult;

  bool get _hasPassed {
    return studentResult.status == StudentExamResultStatus.passed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 18.h,
      ),
      decoration: BoxDecoration(
        color: _cardBackgroundColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: _cardBorderColor,
          width: 1,
        ),
        boxShadow: _hasPassed
            ? [
                BoxShadow(
                  color: ColorPalette.primaryShadow,
                  blurRadius: 8.r,
                  offset: Offset(0, 3.h),
                ),
              ]
            : null,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: _buildStudentInformation(),
          ),
          horizontalSpace(16),
          _buildStudentScore(),
        ],
      ),
    );
  }

  Widget _buildStudentInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          studentResult.studentName,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.font16TextPrimaryBoldTajawal(),
        ),
        verticalSpace(6),
        Text(
          studentResult.gradeName,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.font12TextSecondaryRegularTajawal(),
        ),
      ],
    );
  }

  Widget _buildStudentScore() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: _scoreBackgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        '${studentResult.studentScoreText} / '
        '${studentResult.totalScoreText}',
        textDirection: TextDirection.rtl,
        style: AppTextStyle.font15PrimaryBoldTajawal().copyWith(
          color: _scoreTextColor,
        ),
      ),
    );
  }

  Color get _cardBackgroundColor {
    return switch (studentResult.status) {
      StudentExamResultStatus.passed =>
        ColorPalette.cardBackground,
      StudentExamResultStatus.failed =>
        ColorPalette.error.withValues(alpha: 0.08),
    };
  }

  Color get _cardBorderColor {
    return switch (studentResult.status) {
      StudentExamResultStatus.passed => ColorPalette.border,
      StudentExamResultStatus.failed =>
        ColorPalette.error.withValues(alpha: 0.16),
    };
  }

  Color get _scoreBackgroundColor {
    return switch (studentResult.status) {
      StudentExamResultStatus.passed =>
        ColorPalette.semanticSuccessSoftBg,
      StudentExamResultStatus.failed => Colors.transparent,
    };
  }

  Color get _scoreTextColor {
    return switch (studentResult.status) {
      StudentExamResultStatus.passed => ColorPalette.success,
      StudentExamResultStatus.failed => ColorPalette.error,
    };
  }
}