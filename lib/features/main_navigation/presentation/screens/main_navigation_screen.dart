import 'package:alwaleed_admain/app/routes/route_nav_bottom.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/screens/home_screen.dart';
import 'package:alwaleed_admain/features/main_navigation/presentation/cubit/bottom_navigation_cubit.dart';
import 'package:alwaleed_admain/features/main_navigation/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavigationCubit(),
      child: const MainNavigationView(),
    );
  }
}

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = RouteNavBottom.screens(
      homeScreen: const HomeScreen(),
      contentScreen: const TemporaryScreen(title: 'إدارة المحتوى'),
      examsScreen: const TemporaryScreen(title: 'إدارة الامتحانات'),
      studyNotesScreen: const TemporaryScreen(title: 'إدارة المذكرات'),
      liveSessionScreen: const TemporaryScreen(title: 'الحصص المباشرة'),
    );

    return Scaffold(
      backgroundColor: ColorPalette.background,
      extendBody: true,

      body: BlocBuilder<BottomNavigationCubit, int>(
        builder: (context, currentIndex) {
          return IndexedStack(index: currentIndex, children: screens);
        },
      ),

      bottomNavigationBar: AppAnimations.bottomNavBarEntrance(
        child: BlocBuilder<BottomNavigationCubit, int>(
          builder: (context, currentIndex) {
            return CustomBottomNavBar(
              currentIndex: currentIndex,
              onTap: context.read<BottomNavigationCubit>().changePage,
            );
          },
        ),
      ),
    );
  }
}

class TemporaryScreen extends StatelessWidget {
  const TemporaryScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      body: SafeArea(child: Center(child: Text(title))),
    );
  }
}
