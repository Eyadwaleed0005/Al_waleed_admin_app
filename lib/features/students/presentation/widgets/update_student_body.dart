import 'package:alwaleed_admain/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/update_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/update_student_state.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/update_student_form_fields.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/update_student_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateStudentBody extends StatelessWidget {
  const UpdateStudentBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateStudentCubit, UpdateStudentState>(
      buildWhen: (previous, current) {
        return previous.status != current.status ||
            previous.student != current.student;
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const UpdateStudentLoadingSkeleton();
        }

        if (state.status == UpdateStudentStatus.loadFailure) {
          return AppErrorWidget(
            message: state.error?.message ?? 'تعذر تحميل بيانات الطالب.',
            onRetry: () {
              context.read<UpdateStudentCubit>().loadStudent();
            },
          );
        }

        if (state.student == null) {
          return AppErrorWidget(
            message: 'لم يتم العثور على بيانات الطالب.',
            onRetry: () {
              context.read<UpdateStudentCubit>().loadStudent();
            },
          );
        }

        return const UpdateStudentFormFields();
      },
    );
  }
}
