import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/background_student_feature.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/update_student_body.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/update_student_feedback_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateStudentScreen extends StatelessWidget {
  const UpdateStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: Scaffold(
        backgroundColor: ColorPalette.background,
        body: BackgroundStudentFeature(
          child: SafeArea(
            child: UpdateStudentFeedbackListener(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 20.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SecondaryCustomHeaderBar(
                      title: 'حساب الطالب',
                    ),
                    verticalSpace(24),
                    const Expanded(
                      child: UpdateStudentBody(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
