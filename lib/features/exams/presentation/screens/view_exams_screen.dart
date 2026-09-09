import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/view_exams_screen_widgets/view_exams_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewExamsScreen extends StatelessWidget {
  const ViewExamsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: const ViewExamsContent(),
    );
  }
}