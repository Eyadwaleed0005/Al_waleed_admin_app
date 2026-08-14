import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/add_note_cubit.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/add_note_state.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_content.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_feedback_listener.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AddNoteFeedbackListener(
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
                          title: 'إضافة مذكرة',
                        ),
                      ),

                      verticalSpace(30),

                      Expanded(
                        child: AppAnimations.screenSection(
                          delay: 120,
                          child: BlocBuilder<AddNoteCubit, AddNoteState>(
                            builder: (context, state) {
                              if (state.isPageLoading) {
                                return const AddNoteLoadingSkeleton();
                              }
                              if (state.hasPageFailure && state.error != null) {
                                return AppErrorWidget(
                                  message: state.error!.message,
                                  onRetry: () {
                                    context.read<AddNoteCubit>().retry();
                                  },
                                );
                              }
                              if (state.isPageReady) {
                                return AddNoteContent(state: state);
                              }
                              return const AddNoteLoadingSkeleton();
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
      ),
    );
  }
}
