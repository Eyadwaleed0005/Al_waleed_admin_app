import 'package:alwaleed_admain/app/routes/app_images_routes.dart';
import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/core/helper/app_date_time_formatter.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_empty_widget.dart';
import 'package:alwaleed_admain/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_header_bar.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/view_exams_cubit.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/view_exams_state.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/view_exams_screen_widgets/exam_card.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/view_exams_screen_widgets/exam_search_filter_section.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/view_exams_screen_widgets/exams_list_view.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/view_exams_screen_widgets/view_exams_loading_skeleton.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewExamsContent extends StatelessWidget {
  const ViewExamsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentManagementBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppAnimations.screenSection(
                  delay: 0,
                  child: CustomHeaderBar(
                    title: 'إدارة الاختبارات',
                    iconPath: AppImage().profileIcon,
                  ),
                ),
                verticalSpace(30),
                Expanded(
                  child: BlocBuilder<ViewExamsCubit, ViewExamsState>(
                    builder: _buildState,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildState(BuildContext context, ViewExamsState state) {
    return switch (state) {
      ViewExamsLoading() => const ViewExamsLoadingSkeleton(),

      ViewExamsError(:final error) => AppErrorWidget(
        message: error.message,
        onRetry: context.read<ViewExamsCubit>().retry,
      ),

      ViewExamsEmpty() => AppEmptyWidget(
        title: 'لا توجد اختبارات',
        message: 'لم يتم إنشاء أي اختبارات حتى الآن.',
        actionText: 'إنشاء اختبار جديد',
        icon: Icons.quiz_outlined,
        onActionPressed: () {
          _openAddExamScreen(context);
        },
      ),

      ViewExamsSuccess(:final grades, :final exams) => _buildSuccessContent(
        context: context,
        grades: grades,
        exams: exams,
      ),
    };
  }

  Widget _buildSuccessContent({
    required BuildContext context,
    required List<GradeEntity> grades,
    required List<ExamEntity> exams,
  }) {
    final ViewExamsCubit cubit = context.read<ViewExamsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppAnimations.screenSection(
          delay: 120,
          child: ExamSearchFilterSection(
            grades: grades,
            selectedGradeId: cubit.selectedGradeId,
            selectedPublicationFilter: _mapSelectedFilter(cubit.selectedStatus),
            onSearchChanged: cubit.searchExams,
            onSearchSubmitted: cubit.searchExams,
            onGradeSelected: cubit.selectGrade,
            onPublicationStatusSelected: (filter) {
              cubit.selectStatus(_mapFilterStatus(filter));
            },
          ),
        ),
        verticalSpace(24),
        Expanded(
          child: exams.isEmpty
              ? const AppEmptyWidget(
                  title: 'لا توجد نتائج',
                  message:
                      'لا توجد اختبارات مطابقة للبحث أو عوامل التصفية الحالية.',
                  icon: Icons.search_off_rounded,
                )
              : AppAnimations.screenSection(
                  delay: 240,
                  child: ExamsListView(
                    exams: _mapExamCards(exams: exams, grades: grades),
                    onExamPressed: (card) {
                      final ExamEntity? exam = _findExam(
                        exams: exams,
                        examId: card.examId,
                      );

                      if (exam == null) {
                        return;
                      }

                      _openEditExamScreen(context: context, exam: exam);
                    },
                    onViewResultsPressed: (card) {
                      _openExamResultsScreen(
                        context: context,
                        examId: card.examId,
                      );
                    },
                  ),
                ),
        ),
        verticalSpace(20),
        AppAnimations.screenSection(
          delay: 360,
          child: CustomButton(
            text: 'إنشاء اختبار جديد',
            onPressed: () {
              _openAddExamScreen(context);
            },
          ),
        ),
      ],
    );
  }

  List<ExamCardViewData> _mapExamCards({
    required List<ExamEntity> exams,
    required List<GradeEntity> grades,
  }) {
    return exams
        .map((exam) {
          return ExamCardViewData(
            examId: exam.examId,
            examName: exam.examName,
            gradeName: _getGradeName(gradeId: exam.gradeId, grades: grades),
            questionCount: exam.questionCount,
            totalScore: exam.totalScore,
            durationMinutes: exam.durationMinutes,
            status: exam.status,
            closedDateText: exam.closedAt == null
                ? null
                : AppDateTimeFormatter.formatDate(exam.closedAt!),
          );
        })
        .toList(growable: false);
  }

  ExamEntity? _findExam({
    required List<ExamEntity> exams,
    required String examId,
  }) {
    for (final ExamEntity exam in exams) {
      if (exam.examId == examId) {
        return exam;
      }
    }

    return null;
  }

  String _getGradeName({
    required String gradeId,
    required List<GradeEntity> grades,
  }) {
    for (final GradeEntity grade in grades) {
      if (grade.gradeId == gradeId) {
        return grade.name;
      }
    }

    return 'صف غير معروف';
  }

  ExamPublicationFilter _mapSelectedFilter(ExamStatus? status) {
    return switch (status) {
      null => ExamPublicationFilter.all,
      ExamStatus.unpublished => ExamPublicationFilter.unpublished,
      ExamStatus.published => ExamPublicationFilter.published,
      ExamStatus.ended => ExamPublicationFilter.ended,
    };
  }

  ExamStatus? _mapFilterStatus(ExamPublicationFilter filter) {
    return switch (filter) {
      ExamPublicationFilter.all => null,
      ExamPublicationFilter.unpublished => ExamStatus.unpublished,
      ExamPublicationFilter.published => ExamStatus.published,
      ExamPublicationFilter.ended => ExamStatus.ended,
    };
  }

  void _openAddExamScreen(BuildContext context) {
    Navigator.of(context).pushNamed(RouteNames.addExamScreen);
  }

  void _openEditExamScreen({
    required BuildContext context,
    required ExamEntity exam,
  }) {
    if (exam.examId.trim().isEmpty || exam.isEnded) {
      return;
    }

    Navigator.of(context).pushNamed(RouteNames.editExamScreen, arguments: exam);
  }

  void _openExamResultsScreen({
    required BuildContext context,
    required String examId,
  }) {
    final String normalizedExamId = examId.trim();

    if (normalizedExamId.isEmpty) {
      return;
    }

    Navigator.of(
      context,
    ).pushNamed(RouteNames.examResultsScreen, arguments: normalizedExamId);
  }
}
