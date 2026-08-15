import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/custom_delete_confirmation_bottom_sheet.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/edit_lesson_cubit.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/edit_lesson_state.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/edit_lesson_content.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/edit_lesson_feedback_listener.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/edit_lesson_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditLessonScreen extends StatelessWidget {
  const EditLessonScreen({super.key});

  Future<void> _showDeleteConfirmation({
    required BuildContext context,
    required EditLessonState state,
  }) async {
    if (state.isDeleting || !state.canDelete) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final lessonTitle = state.lesson?.title.trim() ?? '';

    final message = lessonTitle.isNotEmpty
        ? 'هل أنت متأكد من حذف درس "$lessonTitle"؟ '
              'سيتم حذف الدرس وملف PDF الخاص به نهائيًا، '
              'ولا يمكن التراجع عن هذه العملية.'
        : 'هل أنت متأكد من حذف هذا الدرس؟ '
              'سيتم حذف الدرس وملف PDF الخاص به نهائيًا، '
              'ولا يمكن التراجع عن هذه العملية.';

    final confirmed = await showCustomDeleteConfirmationBottomSheet(
      context,
      title: 'حذف الدرس',
      message: message,
      confirmText: 'حذف الدرس',
      cancelText: 'إلغاء',
    );

    if (!context.mounted || !confirmed) {
      return;
    }

    context.read<EditLessonCubit>().deleteLesson();
  }

  @override
  Widget build(BuildContext context) {
    return EditLessonFeedbackListener(
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
                          title: 'تعديل الدرس',
                        ),
                      ),

                      verticalSpace(30),

                      Expanded(
                        child: BlocBuilder<EditLessonCubit, EditLessonState>(
                          builder: (context, state) {
                            if (state.isInitial || state.isPageLoading) {
                              return const EditLessonLoadingSkeleton();
                            }

                            if (state.hasPageFailure) {
                              final error = state.pageError;

                              if (error == null) {
                                return const SizedBox.shrink();
                              }

                              return AppErrorWidget(
                                message: error.message,
                                onRetry: () {
                                  context.read<EditLessonCubit>().retry();
                                },
                              );
                            }

                            if (state.isPageReady) {
                              return EditLessonContent(
                                state: state,
                                onDeletePressed: () {
                                  _showDeleteConfirmation(
                                    context: context,
                                    state: state,
                                  );
                                },
                              );
                            }

                            return const EditLessonLoadingSkeleton();
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
