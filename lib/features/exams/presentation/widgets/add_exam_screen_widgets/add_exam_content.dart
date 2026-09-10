import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_animations.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/widgets/app_empty_widget.dart';
import 'package:alwaleed_admin/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admin/core/widgets/app_loading_indicator.dart';
import 'package:alwaleed_admin/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admin/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/add_exam_cubit.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/add_exam_state.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/add_exam_screen_widgets/add_exam_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddExamContent extends StatelessWidget {
  const AddExamContent({super.key});

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
                  child: const SecondaryCustomHeaderBar(
                    title: 'إنشاء اختبار عام',
                  ),
                ),
                verticalSpace(30),
                Expanded(
                  child: BlocBuilder<AddExamCubit, AddExamState>(
                    builder: _buildState,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildState(BuildContext context, AddExamState state) {
    return switch (state) {
      AddExamLoading() => const Center(
        child: AppLoadingIndicator(
          color: ColorPalette.primary,
          size: 32,
          strokeWidth: 3,
        ),
      ),

      AddExamEmpty() => const AppEmptyWidget(
        title: 'لا توجد صفوف دراسية',
        message: 'يجب إضافة صف دراسي وتفعيله قبل إنشاء الاختبار.',
        icon: Icons.school_outlined,
      ),

      AddExamError(:final error) => AppErrorWidget(
        message: error.message,
        onRetry: context.read<AddExamCubit>().retry,
      ),

      AddExamSuccess(:final grades) => AppAnimations.screenSection(
        delay: 120,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: AddExamForm(grades: grades),
        ),
      ),
    };
  }
}
