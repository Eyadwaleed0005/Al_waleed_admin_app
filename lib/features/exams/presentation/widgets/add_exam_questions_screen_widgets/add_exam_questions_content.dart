import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_draft_entity.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/add_exam_question_cubit.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/add_exam_question_state.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/add_exam_questions_screen_widgets/add_exam_question_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddExamQuestionsContent extends StatelessWidget {
  const AddExamQuestionsContent({super.key, required this.examDraft});

  final ExamDraftEntity examDraft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentManagementBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppAnimations.screenSection(
                  delay: 0,
                  child: const SecondaryCustomHeaderBar(title: 'إضافة سؤال'),
                ),
                verticalSpace(30),
                Expanded(
                  child:
                      BlocConsumer<AddExamQuestionCubit, AddExamQuestionState>(
                        listenWhen:
                            (
                              AddExamQuestionState previous,
                              AddExamQuestionState current,
                            ) {
                              return current is AddExamQuestionSuccess;
                            },
                        listener:
                            (BuildContext context, AddExamQuestionState state) {
                              if (state is! AddExamQuestionSuccess) {
                                return;
                              }

                              Navigator.of(context).pop(state.questionDraft);
                            },
                        builder:
                            (BuildContext context, AddExamQuestionState state) {
                              return _buildContent(
                                context: context,
                                state: state,
                              );
                            },
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required AddExamQuestionState state,
  }) {
    final bool isLoading = state is AddExamQuestionLoading;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: AddExamQuestionForm(
        isAddingQuestion: isLoading,
        onAddQuestionPressed:
            ({
              required String questionText,
              required int questionDegree,
              required List<String> choices,
              image,
            }) {
              context.read<AddExamQuestionCubit>().addQuestion(
                questionText: questionText,
                questionDegree: questionDegree,
                choices: choices,
                image: image,
              );
            },
      ),
    );
  }
}
