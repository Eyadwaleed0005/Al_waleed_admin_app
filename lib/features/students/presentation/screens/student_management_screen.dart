import 'package:alwaleed_admain/app/routes/app_images_routes.dart';
import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_header_bar.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/student_search_filter_section.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/students_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentManagementScreen extends StatelessWidget {
  const StudentManagementScreen({super.key});

  static const List<StudentListItem> students = [
    StudentListItem(
      name: 'عمر أحمد',
      grade: 'الصف الثالث الثانوي',
      isActive: true,
    ),
    StudentListItem(
      name: 'مريم خالد',
      grade: 'الصف الثاني الثانوي',
      isActive: false,
    ),
    StudentListItem(
      name: 'محمد خالد',
      grade: 'الصف الأول الثانوي',
      isActive: true,
    ),
    StudentListItem(
      name: 'أحمد محمود',
      grade: 'الصف الثالث الثانوي',
      isActive: true,
    ),
    StudentListItem(
      name: 'سارة محمد',
      grade: 'الصف الثاني الثانوي',
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark(),
      child: Scaffold(
        backgroundColor: ColorPalette.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 20.h,
            ),
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
                    onSearchChanged: (value) {},
                    onSearchSubmitted: (value) {},
                    onSearchTap: () {},
                    onGradeFilterTap: () {},
                    onStatusFilterTap: () {},
                  ),
                ),

                verticalSpace(30),

                Expanded(
                  child: AppAnimations.screenSection(
                    delay: 200,
                    child: StudentsList(
                      students: students,
                      onStudentTap: (student) {
                        // الانتقال لشاشة بيانات الطالب
                      },
                    ),
                  ),
                ),

                verticalSpace(16),

                AppAnimations.screenSection(
                  delay: 300,
                  child: CustomButton(
                    text: 'إضافة طالب جديد',
                    onPressed: () {
                      // الانتقال لشاشة إضافة طالب
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}