import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admain/core/widgets/app_loading_indicator.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/add_lesson_cubit.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/add_lesson_state.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/add_lesson_content.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/add_lesson_feedback_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddLessonScreen extends StatelessWidget {
  const AddLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AddLessonFeedbackListener(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.light(),
        child: Scaffold(
          body: ContentManagementBackground(
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
                      AppAnimations.screenSection(
                        delay: 0,
                        child: const SecondaryCustomHeaderBar(
                          title: 'إضافة درس جديد',
                        ),
                      ),
                      verticalSpace(30),
                      Expanded(
                        child: BlocBuilder<AddLessonCubit, AddLessonState>(
                          builder: (context, state) {
                            if (state.isPageLoading) {
                              return const Center(child: AppLoadingIndicator());
                            }

                            if (state.hasPageFailure) {
                              return AppErrorWidget(
                                message:
                                    state.error?.message ??
                                    'تعذر تحميل بيانات الصفحة.',
                                onRetry: () {
                                  context.read<AddLessonCubit>().retry();
                                },
                              );
                            }
                            if (state.isPageReady) {
                              return AddLessonContent(state: state);
                            }
                            return const Center(child: AppLoadingIndicator());
                          },
                        ),
                      ),
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
