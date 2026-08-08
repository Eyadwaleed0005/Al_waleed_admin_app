import 'package:alwaleed_admain/app/routes/app_images_routes.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_header_bar.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/students/domain/params/student_params.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/student_management_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/student_search_filter_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentManagementContent extends StatelessWidget {
  const StudentManagementContent({
    super.key,
    required this.grades,
    required this.filters,
    required this.content,
    required this.onAddStudent,
  });

  final List<GradeEntity> grades;
  final StudentsFilterParams filters;
  final Widget content;
  final VoidCallback onAddStudent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppAnimations.screenSection(
            delay: 0,
            child: CustomHeaderBar(
              title: 'إدارة الطلاب',
              iconPath: AppImage().profileIcon,
            ),
          ),

          verticalSpace(30),

          AppAnimations.screenSection(
            delay: 100,
            child: StudentSearchFilterSection(
              grades: grades,
              selectedGradeId: filters.gradeId,
              selectedSubscriptionFilter: filters.subscriptionFilter,
              onSearchChanged: (value) {
                context.read<StudentManagementCubit>().updateSearchQuery(value);
              },
              onSearchSubmitted: (value) {
                context.read<StudentManagementCubit>().updateSearchQuery(value);
              },
              onSearchTap: () {},
              onGradeSelected: (gradeId) {
                context.read<StudentManagementCubit>().updateGradeFilter(
                  gradeId,
                );
              },
              onStatusSelected: (filter) {
                context.read<StudentManagementCubit>().updateSubscriptionFilter(
                  filter,
                );
              },
            ),
          ),

          verticalSpace(30),

          Expanded(
            child: AppAnimations.screenSection(delay: 200, child: content),
          ),

          verticalSpace(16),

          AppAnimations.screenSection(
            delay: 300,
            child: CustomButton(
              text: 'إضافة طالب جديد',
              onPressed: onAddStudent,
            ),
          ),
        ],
      ),
    );
  }
}
