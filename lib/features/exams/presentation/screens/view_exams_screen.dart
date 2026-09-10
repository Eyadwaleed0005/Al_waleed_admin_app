import 'package:alwaleed_admain/app/dependency_injection/service_locator.dart';
import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/stream_exams_use_case.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/view_exams_cubit.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/view_exams_screen_widgets/view_exams_content.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewExamsScreen extends StatelessWidget {
  const ViewExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewExamsCubit>(
      create: (_) {
        return ViewExamsCubit(
          streamExamsUseCase: getIt<StreamExamsUseCase>(),
          streamGradesUseCase: getIt<StreamGradesUseCase>(),
        )..loadData();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.light(),
        child: const ViewExamsContent(),
      ),
    );
  }
}
