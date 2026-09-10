import 'package:alwaleed_admin/core/style/app_animations.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/widgets/backgrounds/background_student_feature.dart';
import 'package:alwaleed_admin/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admin/features/result_student/presentation/cubit/student_exam_results_cubit.dart';
import 'package:alwaleed_admin/features/result_student/presentation/cubit/student_exam_results_state.dart';
import 'package:alwaleed_admin/features/result_student/presentation/widgets/student_exam_results_states/student_exam_results_empty_view.dart';
import 'package:alwaleed_admin/features/result_student/presentation/widgets/student_exam_results_states/student_exam_results_error_view.dart';
import 'package:alwaleed_admin/features/result_student/presentation/widgets/student_exam_results_states/student_exam_results_loading_view.dart';
import 'package:alwaleed_admin/features/result_student/presentation/widgets/student_exam_results_states/student_exam_results_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentExamResultsContent extends StatelessWidget {
  final String studentId;

  const StudentExamResultsContent({required this.studentId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      body: BackgroundStudentFeature(
        child: SafeArea(
          child: Column(
            children: [
              AppAnimations.screenSection(
                delay: 40,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 20.h,
                  ),
                  child: const SecondaryCustomHeaderBar(title: 'نتائج الطالب'),
                ),
              ),
              Expanded(
                child:
                    BlocBuilder<
                      StudentExamResultsCubit,
                      StudentExamResultsState
                    >(
                      builder: (context, state) {
                        if (state is StudentExamResultsInitial ||
                            state is StudentExamResultsLoading) {
                          return const StudentExamResultsLoadingView();
                        }

                        if (state is StudentExamResultsError) {
                          return StudentExamResultsErrorView(
                            studentId: studentId,
                            errorMessage: state.appErrorModel.message,
                          );
                        }

                        if (state is StudentExamResultsEmpty) {
                          return StudentExamResultsEmptyView(
                            studentExamResultsOverview:
                                state.studentExamResultsOverview,
                          );
                        }

                        if (state is StudentExamResultsSuccess) {
                          return StudentExamResultsSuccessView(
                            studentId: studentId,
                            studentExamResultsOverview:
                                state.studentExamResultsOverview,
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
