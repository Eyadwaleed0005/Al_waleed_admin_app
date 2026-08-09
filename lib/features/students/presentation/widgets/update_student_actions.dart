import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_delete_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_delete_confirmation_bottom_sheet.dart';
import 'package:alwaleed_admain/core/widgets/custom_secondary_button.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/update_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/update_student_state.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/view_student_exams_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateStudentActions extends StatelessWidget {
  const UpdateStudentActions({super.key, this.onViewStudentExams});

  final VoidCallback? onViewStudentExams;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateStudentCubit, UpdateStudentState>(
      buildWhen: (previous, current) {
        return previous.status != current.status;
      },
      builder: (context, state) {
        final cubit = context.read<UpdateStudentCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppAnimations.formFieldEntrance(
              order: 6,
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'حفظ التعديلات',
                      onPressed: cubit.submit,
                      isLoading: state.isSubmitting,
                      isEnabled: !state.isBusy,
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: CustomSecondaryButton(
                      text: 'فصل الجهاز',
                      icon: Icons.phonelink_erase_rounded,
                      onPressed: cubit.disconnectDevice,
                      isLoading: state.isDisconnectingDevice,
                      isEnabled: !state.isBusy,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(14),
            AppAnimations.formFieldEntrance(
              order: 7,
              child: CustomSecondaryButton(
                text: 'تجديد اشتراك الطالب',
                icon: Icons.autorenew_rounded,
                onPressed: cubit.renewSubscription,
                isLoading: state.isRenewingSubscription,
                isEnabled: !state.isBusy,
              ),
            ),
            verticalSpace(14),
            AppAnimations.formFieldEntrance(
              order: 8,
              child: Row(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ViewStudentExamsButton(
                    onPressed: onViewStudentExams,
                    isEnabled: !state.isBusy,
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: CustomDeleteButton(
                      text: 'حذف الطالب',
                      isLoading: state.isDeleting,
                      isEnabled: !state.isBusy,
                      onPressed: () async {
                        final confirmed =
                            await showCustomDeleteConfirmationBottomSheet(
                              context,
                              title: 'حذف الطالب؟',
                              message:
                                  'هل أنت متأكد من حذف حساب الطالب؟ لا يمكن التراجع عن هذه العملية.',
                              confirmText: 'حذف الطالب',
                              cancelText: 'إلغاء',
                            );

                        if (!confirmed || !context.mounted) {
                          return;
                        }
                        await context
                            .read<UpdateStudentCubit>()
                            .deleteStudent();
                      },
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(16),
          ],
        );
      },
    );
  }
}
