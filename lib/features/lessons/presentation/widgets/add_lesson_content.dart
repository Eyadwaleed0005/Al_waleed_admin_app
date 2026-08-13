import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/add_lesson_cubit.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/add_lesson_state.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/add_lesson_fields.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/add_lesson_options_section.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/add_lesson_pdf_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddLessonContent extends StatefulWidget {
  const AddLessonContent({super.key, required this.state});

  final AddLessonState state;

  @override
  State<AddLessonContent> createState() {
    return _AddLessonContentState();
  }
}

class _AddLessonContentState extends State<AddLessonContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _youtubeUrlController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.state.title);

    _subtitleController = TextEditingController(text: widget.state.subtitle);

    _youtubeUrlController = TextEditingController(
      text: widget.state.youtubeUrl,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _youtubeUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cubit = context.read<AddLessonCubit>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppAnimations.formFieldEntrance(
                    order: 0,
                    child: AddLessonTitleField(
                      controller: _titleController,
                      enabled: !state.isSubmitting,
                      onChanged: cubit.changeTitle,
                    ),
                  ),

                  verticalSpace(18),

                  AppAnimations.formFieldEntrance(
                    order: 1,
                    child: AddLessonSubtitleField(
                      controller: _subtitleController,
                      enabled: !state.isSubmitting,
                      onChanged: cubit.changeSubtitle,
                    ),
                  ),

                  verticalSpace(20),

                  AppAnimations.formFieldEntrance(
                    order: 2,
                    child: AddLessonOptionsSection(
                      grades: state.grades,
                      selectedGradeId: state.selectedGradeId,
                      isPublished: state.isPublished,
                      enabled: !state.isSubmitting,
                      onGradeSelected: cubit.selectGrade,
                      onPublicationChanged: cubit.changePublicationStatus,
                    ),
                  ),

                  verticalSpace(50),

                  AppAnimations.formFieldEntrance(
                    order: 3,
                    child: AddLessonYoutubeUrlField(
                      controller: _youtubeUrlController,
                      enabled: !state.isSubmitting,
                      onChanged: cubit.changeYoutubeUrl,
                    ),
                  ),

                  verticalSpace(20),
                  AppAnimations.formFieldEntrance(
                    order: 4,
                    child: AddLessonPdfPicker(
                      onFileSelected: (file) {
                        final path = file.path?.trim();

                        if (path == null || path.isEmpty) {
                          return;
                        }

                        cubit.selectPdf(
                          AddLessonPdfFile(
                            name: file.name,
                            path: path,
                            sizeInBytes: file.size,
                          ),
                        );
                      },
                      onFileRemoved: cubit.removePdf,
                    ),
                  ),
                ],
              ),
            ),
          ),

          verticalSpace(16),
          SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: 4.h),
            child: AppAnimations.screenSection(
              delay: 420,
              child: CustomButton(
                text: 'إضافة الدرس',
                isLoading: state.isSubmitting,
                isEnabled: state.canSubmit,
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();

                  final isFormValid =
                      _formKey.currentState?.validate() ?? false;

                  if (!isFormValid) {
                    return;
                  }
                  cubit.createLesson();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
