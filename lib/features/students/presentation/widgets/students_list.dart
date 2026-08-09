import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/student_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentsList extends StatelessWidget {
  const StudentsList({
    super.key,
    required this.students,
    required this.grades,
    required this.onStudentTap,
  });

  final List<StudentEntity> students;
  final List<GradeEntity> grades;
  final ValueChanged<StudentEntity> onStudentTap;

  @override
  Widget build(BuildContext context) {
    final gradeNames = <String, String>{
      for (final grade in grades) grade.gradeId: grade.name,
    };

    return ListView.separated(
      padding: EdgeInsets.only(bottom: 20.h),
      itemCount: students.length,
      separatorBuilder: (_, __) {
        return verticalSpace(12);
      },
      itemBuilder: (context, index) {
        final student = students[index];
        final gradeName = gradeNames[student.gradeId] ?? 'صف غير معروف';
        final isActive =
            student.isActive &&
            student.subscriptionEndAt.isAfter(DateTime.now());
        return StudentCard(
          name: student.name,
          grade: gradeName,
          isActive: isActive,
          onTap: () {
            onStudentTap(student);
          },
        );
      },
    );
  }
}
