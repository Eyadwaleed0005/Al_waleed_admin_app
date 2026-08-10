import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_operation_result_dialog.dart';
import 'package:alwaleed_admain/core/widgets/custom_popup_menu_field.dart';
import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:alwaleed_admain/features/live_session/presentation/cubit/live_session_cubit.dart';
import 'package:alwaleed_admain/features/live_session/presentation/cubit/live_session_state.dart';
import 'package:alwaleed_admain/features/live_session/presentation/widgets/live_session_welcome.dart';
import 'package:alwaleed_admain/features/live_session/presentation/widgets/meeting_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveSessionForm extends StatelessWidget {
  const LiveSessionForm({super.key, required this.state});

  final LiveSessionState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LiveSessionCubit>();

    final gradeItems = state.grades.map((grade) {
      return PopupSelectionItem<String>(
        value: grade.gradeId,
        label: grade.name,
      );
    }).toList();

    final selectedGradeText = state.selectedGrade?.name ?? 'حدد الصف الدراسي';

    return BlocListener<LiveSessionCubit, LiveSessionState>(
      listenWhen: (previous, current) {
        return previous.status != current.status &&
            current.status == LiveSessionStatus.failure &&
            current.errorModel != null;
      },
      listener: (context, currentState) {
        final errorModel = currentState.errorModel;

        if (errorModel == null) {
          return;
        }

        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            return CustomOperationResultDialog(
              type: CustomOperationResultType.failure,
              title: 'تعذر تنفيذ العملية',
              message: errorModel.message,
              actionText: 'حسنًا',
              onActionPressed: () {
                Navigator.of(dialogContext).pop();
              },
            );
          },
        ).whenComplete(() {
          if (!cubit.isClosed) {
            cubit.clearError();
          }
        });
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LiveSessionWelcome(),

            verticalSpace(24),

            Text(
              'اختر الصف',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTextStyle.font15TextPrimaryMediumTajawal(),
            ),

            verticalSpace(10),

            CustomPopupMenuField<String>(
              items: gradeItems,
              value: state.selectedGradeId,
              selectedText: selectedGradeText,
              filterValue: state.selectedGradeId,
              tooltip: 'اختر الصف الدراسي',
              emptyTooltip: state.isGradesLoading
                  ? 'جارٍ تحميل الصفوف'
                  : 'لا توجد صفوف متاحة',
              enabled: !state.isGradesLoading,
              onSelected: cubit.selectGrade,
            ),

            verticalSpace(24),

            Text(
              'منصة البث',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTextStyle.font15TextPrimaryMediumTajawal(),
            ),

            verticalSpace(10),

            MeetingTypeSelector(
              selectedType: state.selectedMeetingType,
              onChanged: cubit.selectMeetingType,
            ),

            verticalSpace(24),

            CustomTextFormField(
              controller: cubit.sessionLinkController,
              labelText: 'رابط الحصة',
              hintText: 'https://zoom.us/j/chem-2026',
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              textDirection: TextDirection.ltr,
              isRequired: true,
              validator: AppValidator.liveSessionUrl,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),

            verticalSpace(24),

            CustomButton(
              text: 'إضافة رابط',
              isLoading: state.isSaving,
              isEnabled: state.canSave,
              onPressed: () {
                FocusScope.of(context).unfocus();

                cubit.saveLiveSession();
              },
            ),

            verticalSpace(24),
          ],
        ),
      ),
    );
  }
}
