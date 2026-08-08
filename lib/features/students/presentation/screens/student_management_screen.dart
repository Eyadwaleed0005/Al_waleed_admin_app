import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/widgets/app_empty_widget.dart';
import 'package:alwaleed_admain/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admain/core/widgets/app_no_search_results_widget.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/student_management_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/student_management_state.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/student_management_content.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/student_management_skeleton.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/students_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentManagementScreen extends StatelessWidget {
  const StudentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: Scaffold(
        backgroundColor: ColorPalette.background,
        body: SafeArea(
          child: BlocBuilder<
              StudentManagementCubit,
              StudentManagementState>(
            builder: (context, state) {
              return switch (state) {
                StudentManagementInitial() ||
                StudentManagementLoading() =>
                  const StudentManagementSkeleton(),

                StudentManagementFailure(:final error) =>
                  AppErrorWidget(
                    message: error.message,
                    onRetry: () {
                      context
                          .read<StudentManagementCubit>()
                          .watchStudentManagement();
                    },
                  ),

                StudentManagementEmpty() =>
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 20.h,
                    ),
                    child: AppEmptyWidget(
                      title: 'لا يوجد طلاب بعد',
                      message:
                          'ابدأ بإضافة أول طالب وإنشاء حسابه لمتابعة الدروس والاختبارات.',
                      actionText: 'إضافة طالب',
                      icon: Icons.person_outline_rounded,
                      onActionPressed: () {
                        // الانتقال لشاشة إضافة الطالب.
                      },
                    ),
                  ),

                StudentManagementNoSearchResults(
                  :final grades,
                  :final filters,
                ) =>
                  StudentManagementContent(
                    grades: grades,
                    filters: filters,
                    onAddStudent: () {
                      // الانتقال لشاشة إضافة الطالب.
                    },
                    content:
                        const AppNoSearchResultsWidget(
                      message:
                          'جرب البحث باسم آخر أو تغيير الفلاتر المستخدمة.',
                    ),
                  ),

                StudentManagementLoaded(
                  :final students,
                  :final grades,
                  :final filters,
                ) =>
                  StudentManagementContent(
                    grades: grades,
                    filters: filters,
                    onAddStudent: () {
                      // الانتقال لشاشة إضافة الطالب.
                    },
                    content: StudentsList(
                      students: students,
                      grades: grades,
                      onStudentTap: (student) {
                        // الانتقال لشاشة تعديل الطالب.
                      },
                    ),
                  ),
              };
            },
          ),
        ),
      ),
    );
  }
}