import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/add_note_cubit.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/add_note_state.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_description_field.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_hint_card.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_options_section.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_pdf_picker.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_title_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNoteContent extends StatefulWidget {
  const AddNoteContent({super.key, required this.state});

  final AddNoteState state;

  @override
  State<AddNoteContent> createState() {
    return _AddNoteContentState();
  }
}

class _AddNoteContentState extends State<AddNoteContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.state.title);

    _descriptionController = TextEditingController(
      text: widget.state.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cubit = context.read<AddNoteCubit>();

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
                  AppAnimations.screenSection(
                    delay: 0,
                    child: const AddNoteHintCard(),
                  ),

                  verticalSpace(24),

                  AppAnimations.formFieldEntrance(
                    order: 0,
                    child: AddNoteTitleField(
                      controller: _titleController,
                      onChanged: cubit.changeTitle,
                    ),
                  ),

                  verticalSpace(18),

                  AppAnimations.formFieldEntrance(
                    order: 1,
                    child: AddNoteDescriptionField(
                      controller: _descriptionController,
                      onChanged: cubit.changeDescription,
                    ),
                  ),

                  verticalSpace(20),

                  AppAnimations.formFieldEntrance(
                    order: 2,
                    child: AddNoteOptionsSection(
                      grades: state.grades,
                      selectedGradeId: state.selectedGradeId,
                      isPublished: state.isPublished,
                      onGradeSelected: cubit.selectGrade,
                      onPublicationChanged: cubit.changePublicationStatus,
                    ),
                  ),

                  verticalSpace(20),

                  AppAnimations.formFieldEntrance(
                    order: 3,
                    child: AddNotePdfPicker(
                      onFileSelected: (file) {
                        final path = file.path?.trim();

                        if (path == null || path.isEmpty) {
                          return;
                        }

                        cubit.selectPdf(
                          AddNotePdfFile(
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
              delay: 360,
              child: CustomButton(
                text: 'إضافة المذكرة',
                isLoading: state.isSubmitting,
                isEnabled: state.canSubmit,
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();

                  final isFormValid =
                      _formKey.currentState?.validate() ?? false;

                  if (!isFormValid) {
                    return;
                  }

                  cubit.createNote();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
