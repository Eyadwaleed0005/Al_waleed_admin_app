import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_empty_widget.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/exam_results_screen_widgets/exam_results_ui_helper.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/exam_results_screen_widgets/exam_results_welcome_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamResultsEmptyView extends StatelessWidget {
  const ExamResultsEmptyView({super.key, required this.exam});

  final ExamEntity exam;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      sliver: SliverMainAxisGroup(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: AppAnimations.screenSection(
              delay: 120,
              child: ExamResultsWelcomeCard(
                examName: exam.examName,
                examDetailsText: ExamResultsUiHelper.buildExamDetailsText(exam),
              ),
            ),
          ),
          SliverToBoxAdapter(child: verticalSpace(24)),
          const SliverToBoxAdapter(
            child: AppEmptyWidget(
              title: 'لا توجد نتائج حتى الآن',
              message: 'ستظهر نتائج الطلاب هنا بمجرد أن يرسل أي طالب إجاباته.',
              icon: Icons.assignment_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
