import 'package:alwaleed_admin/app/dependency_injection/app_dependencies/app_dependencies.dart';
import 'package:alwaleed_admin/app/dependency_injection/app_dependencies/core_dependencies.dart';
import 'package:alwaleed_admin/app/dependency_injection/features/dashboard_dependencies.dart';
import 'package:alwaleed_admin/app/dependency_injection/features/exams_dependencies.dart';
import 'package:alwaleed_admin/app/dependency_injection/features/grades_dependencies.dart';
import 'package:alwaleed_admin/app/dependency_injection/features/lesson_exams_dependencies.dart';
import 'package:alwaleed_admin/app/dependency_injection/features/lessons_dependencies.dart';
import 'package:alwaleed_admin/app/dependency_injection/features/live_session_dependencies.dart';
import 'package:alwaleed_admin/app/dependency_injection/features/student_exam_results_dependencies.dart';
import 'package:alwaleed_admin/app/dependency_injection/features/students_dependencies.dart';
import 'package:alwaleed_admin/app/dependency_injection/features/study_notes_dependencies.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  registerCoreDependencies(getIt);
  registerStudentsDependencies(getIt);
  registerLiveSessionDependencies(getIt);
  registerGradesDependencies(getIt);
  registerDashboardDependencies(getIt);
  registerStudyNotesDependencies(getIt);
  registerLessonsDependencies(getIt);
  registerLessonExamsDependencies(getIt);
  registerExamsDependencies(getIt);
  registerStudentExamResultsDependencies(getIt);
  registerAppDependencies(getIt);
}