import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/add_exam_screen_widgets/add_exam_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddExamScreen extends StatelessWidget {
  const AddExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: const AddExamContent(),
    );
  }
}
