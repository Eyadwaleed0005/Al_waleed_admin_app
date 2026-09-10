import 'package:alwaleed_admain/app/routes/feature_routes/app_startup_routes.dart';
import 'package:alwaleed_admain/app/routes/feature_routes/dashboard_routes.dart';
import 'package:alwaleed_admain/app/routes/feature_routes/exams_routes.dart';
import 'package:alwaleed_admain/app/routes/feature_routes/lesson_exams_routes.dart';
import 'package:alwaleed_admain/app/routes/feature_routes/lessons_routes.dart';
import 'package:alwaleed_admain/app/routes/feature_routes/live_session_routes.dart';
import 'package:alwaleed_admain/app/routes/feature_routes/main_navigation_routes.dart';
import 'package:alwaleed_admain/app/routes/feature_routes/student_exam_results_routes.dart';
import 'package:alwaleed_admain/app/routes/feature_routes/student_routes.dart';
import 'package:alwaleed_admain/app/routes/feature_routes/study_notes_routes.dart';

import 'package:flutter/material.dart';

abstract final class AppRoutes {
  const AppRoutes._();

 static Route<dynamic>? generateRoute(RouteSettings settings) {
  return AppStartupRoutes.generateRoute(settings) ??
      DashboardRoutes.generateRoute(settings) ??
      MainNavigationRoutes.generateRoute(settings) ??
      StudentRoutes.generateRoute(settings) ??
      StudentExamResultsRoutes.generateRoute(settings) ??
      ExamsRoutes.generateRoute(settings) ??
      LessonExamsRoutes.generateRoute(settings) ??
      LessonsRoutes.generateRoute(settings) ??
      StudyNotesRoutes.generateRoute(settings) ??
      LiveSessionRoutes.generateRoute(settings);
}
}
