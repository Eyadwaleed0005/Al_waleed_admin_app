import 'package:alwaleed_admain/app/routes/app_images_routes.dart';
import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/widgets/custom_header_bar.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/widgets/quick_actions_section.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/widgets/students_overview_cards.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/widgets/welcome_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: Scaffold(
        backgroundColor: ColorPalette.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              children: [
                AppAnimations.screenSection(
                  delay: 0,
                  child: CustomHeaderBar(
                    title: 'لوحة التحكم',
                    iconPath: AppImage().profileIcon,
                  ),
                ),
                verticalSpace(35),
                AppAnimations.screenSection(
                  delay: 100,
                  child: const WelcomeCard(),
                ),
                verticalSpace(20),
                AppAnimations.screenSection(
                  delay: 200,
                  child: const StudentsOverviewCards(
                    totalStudents: 250,
                    expiredSubscriptions: 45,
                  ),
                ),
                verticalSpace(24),
                AppAnimations.screenSection(
                  delay: 300,
                  child: QuickActionsSection(
                    onStudentsTap: () {},
                    onContentTap: () {},
                    onExamsTap: () {},
                    onResultsTap: () {},
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
