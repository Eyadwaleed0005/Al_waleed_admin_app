import 'package:alwaleed_admin/core/helper/app_system_ui.dart';
import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admin/core/widgets/backgrounds/background_student_feature.dart';
import 'package:alwaleed_admin/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admin/features/students/presentation/widgets/add_student_feedback_listener.dart';
import 'package:alwaleed_admin/features/students/presentation/widgets/add_student_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddStudentScreen extends StatelessWidget {
  const AddStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AddStudentFeedbackListener(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.dark(),
        child: Scaffold(
          backgroundColor: ColorPalette.background,
          body: BackgroundStudentFeature(
            child: SafeArea(
              child: AppNetworkAwareContent(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SecondaryCustomHeaderBar(title: 'إضافة حساب طالب'),
                      verticalSpace(24),
                      const Expanded(child: AddStudentFormFields()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
