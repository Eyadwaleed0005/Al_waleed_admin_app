import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/core/helper/app_date_time_formatter.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_empty_widget.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/view_exams_cubit.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/view_exams_screen_widgets/exam_card.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/view_exams_screen_widgets/exam_search_filter_section.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewExamsSuccessView extends StatelessWidget {
  const ViewExamsSuccessView({
    super.key,
    required this.grades,
    required this.exams,
  });

  final List<GradeEntity> grades;
  final List<ExamEntity> exams;

  @override
  Widget build(BuildContext context) {
    final ViewExamsCubit cubit = context.read<ViewExamsCubit>();

    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          sliver: SliverToBoxAdapter(
            child: AppAnimations.screenSection(
              delay: 120,
              child: ExamSearchFilterSection(
                grades: grades,
                selectedGradeId: cubit.selectedGradeId,
                selectedPublicationFilter: _mapSelectedFilter(
                  cubit.selectedStatus,
                ),
                onSearchChanged: cubit.searchExams,
                onSearchSubmitted: cubit.searchExams,
                onGradeSelected: cubit.selectGrade,
                onPublicationStatusSelected: (ExamPublicationFilter filter) {
                  cubit.selectStatus(_mapFilterStatus(filter));
                },
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: verticalSpace(24)),
        if (exams.isEmpty)
          SliverPadding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
            sliver: const SliverFillRemaining(
              hasScrollBody: true,
              child: AppEmptyWidget(
                title: 'لا توجد نتائج',
                message:
                    'لا توجد اختبارات مطابقة للبحث '
                    'أو عوامل التصفية الحالية.',
                icon: Icons.search_off_rounded,
              ),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
            sliver: _buildExamsSliverList(context),
          ),
      ],
    );
  }

  Widget _buildExamsSliverList(BuildContext context) {
    final List<ExamCardViewData> cards = _mapExamCards();

    final int itemsCount = cards.length * 2 - 1;

    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        if (index.isOdd) {
          return verticalSpace(14);
        }

        final int examIndex = index ~/ 2;
        final ExamCardViewData card = cards[examIndex];

        return AppAnimations.screenSection(
          delay: 240,
          child: ExamCard(
            exam: card,
            onExamPressed: () {
              final ExamEntity? exam = _findExam(examId: card.examId);

              if (exam == null) {
                return;
              }

              _openEditExamScreen(context: context, exam: exam);
            },
            onViewResultsPressed: card.status == ExamStatus.ended
                ? () {
                    _openExamResultsScreen(
                      context: context,
                      examId: card.examId,
                    );
                  }
                : null,
          ),
        );
      }, childCount: itemsCount),
    );
  }

  List<ExamCardViewData> _mapExamCards() {
    return exams
        .map((ExamEntity exam) {
          return ExamCardViewData(
            examId: exam.examId,
            examName: exam.examName,
            gradeName: _getGradeName(gradeId: exam.gradeId),
            questionCount: exam.questionCount,
            totalScore: exam.totalScore,
            durationMinutes: exam.durationMinutes,
            participantsCount: exam.participantsCount,
            status: exam.status,
            closedDateText: exam.closedAt == null
                ? null
                : AppDateTimeFormatter.formatDate(exam.closedAt!),
          );
        })
        .toList(growable: false);
  }

  ExamEntity? _findExam({required String examId}) {
    for (final ExamEntity exam in exams) {
      if (exam.examId == examId) {
        return exam;
      }
    }

    return null;
  }

  String _getGradeName({required String gradeId}) {
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

  void _openEditExamScreen({
    required BuildContext context,
    required ExamEntity exam,
  }) {
    if (exam.examId.trim().isEmpty) {
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
