import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/custom_delete_confirmation_bottom_sheet.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/edit_note_cubit.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/edit_note_state.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/edit_note_content.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/edit_note_feedback_listener.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/edit_note_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditNoteScreen extends StatelessWidget {
  const EditNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EditNoteFeedbackListener(
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
                          title: 'تعديل المذكرة',
                        ),
                      ),

                      verticalSpace(30),

                      Expanded(
                        child: BlocBuilder<EditNoteCubit, EditNoteState>(
                          builder: (context, state) {
                            if (state.isInitial || state.isPageLoading) {
                              return const EditNoteLoadingSkeleton();
                            }

                            if (state.hasPageFailure) {
                              return AppErrorWidget(
                                message:
                                    state.pageError?.message ??
                                    'تعذر تحميل بيانات المذكرة.',
                                onRetry: () {
                                  context.read<EditNoteCubit>().retry();
                                },
                              );
                            }

                            if (state.isPageReady) {
                              return EditNoteContent(
                                state: state,
                                onDeletePressed: () async {
                                  if (state.isDeleting || !state.canDelete) {
                                    return;
                                  }

                                  FocusManager.instance.primaryFocus?.unfocus();

                                  final noteName = state.note?.name.trim();

                                  final confirmed =
                                      await showCustomDeleteConfirmationBottomSheet(
                                        context,
                                        title: 'حذف المذكرة',
                                        message:
                                            noteName != null &&
                                                noteName.isNotEmpty
                                            ? 'هل أنت متأكد من حذف مذكرة "$noteName"؟ سيتم حذف المذكرة وملف PDF الخاص بها نهائيًا، ولا يمكن التراجع عن هذه العملية.'
                                            : 'هل أنت متأكد من حذف هذه المذكرة؟ سيتم حذف المذكرة وملف PDF الخاص بها نهائيًا، ولا يمكن التراجع عن هذه العملية.',
                                        confirmText: 'حذف المذكرة',
                                        cancelText: 'إلغاء',
                                      );

                                  if (!context.mounted || !confirmed) {
                                    return;
                                  }

                                  context.read<EditNoteCubit>().deleteNote();
                                },
                              );
                            }

                            return const EditNoteLoadingSkeleton();
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
