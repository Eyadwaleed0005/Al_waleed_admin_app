import 'package:alwaleed_admain/app/routes/app_images_routes.dart';
import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/widgets/app_loading_indicator.dart';
import 'package:alwaleed_admain/core/widgets/app_refresh_indicator.dart';
import 'package:alwaleed_admain/core/widgets/custom_header_bar.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/cubit/home_dashboard_cubit.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/cubit/home_dashboard_state.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/widgets/quick_actions_section.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/widgets/students_overview_cards.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/widgets/welcome_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          child: AppRefreshIndicator(
            onRefresh: () {
              return context
                  .read<HomeDashboardCubit>()
                  .refreshStudentsSummary();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                    child: BlocBuilder<HomeDashboardCubit, HomeDashboardState>(
                      builder: (context, state) {
                        return switch (state) {
                          HomeDashboardInitial() ||
                          HomeDashboardLoading() => SizedBox(
                            height: 140.h,
                            child: const Center(
                              child: AppLoadingIndicator(
                                color: ColorPalette.primary,
                                size: 32,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                          HomeDashboardLoaded(:final summary) =>
                            StudentsOverviewCards(
                              totalStudents: summary.totalStudents,
                              expiredSubscriptions:
                                  summary.expiredSubscriptions,
                            ),
                        };
                      },
                    ),
                  ),
                  verticalSpace(24),
                  AppAnimations.screenSection(
                    delay: 300,
                    child: QuickActionsSection(
                      onStudentsTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed(RouteNames.addStudentScreen);
                      },
                      onContentTap: () {},
                      onExamsTap: () {},
                      onLiveLinkTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
