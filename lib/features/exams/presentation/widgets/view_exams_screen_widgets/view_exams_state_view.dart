import 'package:alwaleed_admin/core/widgets/app_empty_widget.dart';
import 'package:alwaleed_admin/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/view_exams_cubit.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/view_exams_state.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/view_exams_screen_widgets/view_exams_loading_skeleton.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/view_exams_screen_widgets/view_exams_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewExamsStateView extends StatelessWidget {
  const ViewExamsStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewExamsCubit, ViewExamsState>(
      builder: (BuildContext context, ViewExamsState state) {
        return switch (state) {
          ViewExamsLoading() => SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            sliver: const SliverFillRemaining(
              hasScrollBody: true,
              child: ViewExamsLoadingSkeleton(),
            ),
          ),

          ViewExamsError(:final error) => SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            sliver: SliverFillRemaining(
              hasScrollBody: true,
              child: AppErrorWidget(
                message: error.message,
                onRetry: context.read<ViewExamsCubit>().retry,
              ),
            ),
          ),

          ViewExamsEmpty() => SliverPadding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
            sliver: const SliverFillRemaining(
              hasScrollBody: true,
              child: AppEmptyWidget(
                title: 'لا توجد اختبارات',
                message: 'لم يتم إنشاء أي اختبارات حتى الآن.',
                icon: Icons.quiz_outlined,
              ),
            ),
          ),

          ViewExamsSuccess(:final grades, :final exams) => ViewExamsSuccessView(
            grades: grades,
            exams: exams,
          ),
        };
      },
    );
  }
}
