import 'package:alwaleed_admain/features/students/presentation/widgets/student_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentListItem {
  const StudentListItem({
    required this.name,
    required this.grade,
    required this.isActive,
  });

  final String name;
  final String grade;
  final bool isActive;
}

class StudentsList extends StatelessWidget {
  const StudentsList({
    super.key,
    required this.students,
    required this.onStudentTap,
  });

  final List<StudentListItem> students;
  final ValueChanged<StudentListItem> onStudentTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 20.h),
      itemCount: students.length,
      separatorBuilder: (context, index) {
        return SizedBox(height: 12.h);
      },
      itemBuilder: (context, index) {
        final student = students[index];

        return StudentCard(
          name: student.name,
          grade: student.grade,
          isActive: student.isActive,
          onTap: () {
            onStudentTap(student);
          },
        );
      },
    );
  }
}