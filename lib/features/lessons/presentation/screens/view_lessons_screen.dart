import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/view_lessons_cubit.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/view_lessons_state.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/view_lessons_content.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/view_lessons_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewLessonsScreen extends StatelessWidget {
  const ViewLessonsScreen({
    super.key,
    this.onAddLessonPressed,
    this.onLessonTap,
  });

  final VoidCallback? onAddLessonPressed;
  final ValueChanged<LessonEntity>? onLessonTap;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: Scaffold(
        body: ContentManagementBackground(
          child: SafeArea(
            child: AppNetworkAwareContent(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppAnimations.screenSection(
                      delay: 0,
                      child: const SecondaryCustomHeaderBar(
                        title: 'عرض الدروس',
                      ),
                    ),
                    verticalSpace(30),
                    Expanded(
                      child: AppAnimations.screenSection(
                        delay: 120,
                        child: BlocBuilder<ViewLessonsCubit, ViewLessonsState>(
                          builder: (context, state) {
                            if (state is ViewLessonsInitial ||
                                state is ViewLessonsLoading) {
                              return const ViewLessonsLoadingSkeleton();
                            }

                            if (state is ViewLessonsFailure) {
                              return AppErrorWidget(
                                message: state.message,
                                onRetry: () {
                                  context.read<ViewLessonsCubit>().retry();
                                },
                              );
                            }

                            if (state is ViewLessonsDataSuccess) {
                              return ViewLessonsContent(
                                state: state,
                                onAddLessonPressed: () {
                                  final callback = onAddLessonPressed;

                                  if (callback != null) {
                                    callback();
                                    return;
                                  }

                                  Navigator.of(
                                    context,
                                  ).pushNamed(RouteNames.addLessonScreen);
                                },
                                onLessonTap: (lesson) {
                                  final callback = onLessonTap;

                                  if (callback != null) {
                                    callback(lesson);
                                  }
                                },
                              );
                            }

                            return const ViewLessonsLoadingSkeleton();
                          },
                        ),
                      ),
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
