import 'package:alwaleed_admin/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/exam_results_cubit.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/exam_results_state.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_results_screen_widgets/exam_results_empty_view.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_results_screen_widgets/exam_results_loading_skeleton.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_results_screen_widgets/exam_results_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamResultsStateView extends StatelessWidget {
  const ExamResultsStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamResultsCubit, ExamResultsState>(
      builder: (BuildContext context, ExamResultsState state) {
        if (state is ExamResultsInitial || state is ExamResultsLoading) {
          return SliverPadding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
            sliver: const SliverFillRemaining(
              hasScrollBody: true,
              child: ExamResultsLoadingSkeleton(),
            ),
          );
        }

        if (state is ExamResultsEmpty) {
          return ExamResultsEmptyView(exam: state.exam);
        }

        if (state is ExamResultsError) {
          return SliverPadding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
            sliver: SliverFillRemaining(
              hasScrollBody: true,
              child: AppErrorWidget(
                message: state.error.message,
                onRetry: context.read<ExamResultsCubit>().retry,
              ),
            ),
          );
        }

        if (state is ExamResultsSuccess) {
          return ExamResultsSuccessView(report: state.report);
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
