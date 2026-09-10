import 'package:alwaleed_admin/app/routes/route_nav_bottom.dart';
import 'package:alwaleed_admin/core/style/app_animations.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/features/dashboard/presentation/screens/home_screen.dart';
import 'package:alwaleed_admin/features/exams/presentation/screens/view_exams_screen.dart';
import 'package:alwaleed_admin/features/live_session/presentation/screens/live_session_screen.dart';
import 'package:alwaleed_admin/features/main_navigation/presentation/cubit/bottom_navigation_cubit.dart';
import 'package:alwaleed_admin/features/main_navigation/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:alwaleed_admin/features/students/presentation/screens/student_management_screen.dart';
import 'package:alwaleed_admin/features/study_notes/presentation/screens/content_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavigationCubit(),
      child: const MainNavigationView(),
    );
  }
}

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = RouteNavBottom.screens(
      homeScreen: const HomeScreen(),
      students: const StudentManagementScreen(),
      examsScreen: const ViewExamsScreen(),
      studyNotesScreen: const ContentManagementScreen(),
      liveSessionScreen: const LiveSessionScreen(),
    );

    return Scaffold(
      backgroundColor: ColorPalette.background,
      extendBody: true,
      body: BlocBuilder<BottomNavigationCubit, int>(
        buildWhen: (previousIndex, currentIndex) {
          return previousIndex != currentIndex;
        },
        builder: (context, currentIndex) {
          return KeyedSubtree(
            key: ValueKey<int>(currentIndex),
            child: screens[currentIndex],
          );
        },
      ),
      bottomNavigationBar: AppAnimations.bottomNavBarEntrance(
        child: BlocBuilder<BottomNavigationCubit, int>(
          buildWhen: (previousIndex, currentIndex) {
            return previousIndex != currentIndex;
          },
          builder: (context, currentIndex) {
            return CustomBottomNavBar(
              currentIndex: currentIndex,
              onTap: (newIndex) {
                context.read<BottomNavigationCubit>().changePage(newIndex);
              },
            );
          },
        ),
      ),
    );
  }
}


