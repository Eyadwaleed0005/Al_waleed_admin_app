import 'package:alwaleed_admin/core/helper/app_validator.dart';
import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_animations.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/style/textstyles.dart';
import 'package:alwaleed_admin/core/widgets/custom_date_picker_field.dart';
import 'package:alwaleed_admin/features/students/presentation/cubit/add_student_cubit.dart';
import 'package:alwaleed_admin/features/students/presentation/cubit/add_student_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSubscriptionFields extends StatelessWidget {
  const StudentSubscriptionFields({super.key, required this.state});

  final AddStudentState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddStudentCubit>();

    final hasSubscriptionDates =
        state.subscriptionStartDate != null ||
        state.subscriptionEndDate != null;

    return AppAnimations.formFieldEntrance(
      order: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomDatePickerField(
                  controller: cubit.subscriptionStartDateController,
                  labelText: 'بداية الاشتراك',
                  hintText: 'اختياري',
                  enabled: !state.isSubmitting,
                  isRequired: false,
                  selectedDate: state.subscriptionStartDate,
                  initialDate: state.subscriptionStartDate,
                  firstDate: cubit.today,
                  validator: (_) {
                    final currentState = cubit.state;
                    final startDate = currentState.subscriptionStartDate;
                    final endDate = currentState.subscriptionEndDate;

                    if (startDate == null && endDate == null) {
                      return null;
                    }

                    return AppValidator.subscriptionStartDate(startDate);
                  },
                  onDateSelected: cubit.selectSubscriptionStartDate,
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: CustomDatePickerField(
                  controller: cubit.subscriptionEndDateController,
                  labelText: 'نهاية الاشتراك',
                  hintText: 'اختياري',
                  enabled: !state.isSubmitting,
                  isRequired: false,
                  selectedDate: state.subscriptionEndDate,
                  initialDate: state.subscriptionEndDate,
                  firstDate: cubit.subscriptionEndFirstDate,
                  validator: (_) {
                    final currentState = cubit.state;
                    final startDate = currentState.subscriptionStartDate;
                    final endDate = currentState.subscriptionEndDate;

                    if (startDate == null && endDate == null) {
                      return null;
                    }

                    return AppValidator.subscriptionEndDate(
                      startDate: startDate,
                      endDate: endDate,
                    );
                  },
                  onDateSelected: cubit.selectSubscriptionEndDate,
                ),
              ),
            ],
          ),
          verticalSpace(8),
          Text(
            'اترك التاريخين فارغين لإضافة الطالب بدون اشتراك.',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTextStyle.font12TextSecondaryRegularTajawal(),
          ),
          if (hasSubscriptionDates)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: state.isSubmitting
                    ? null
                    : cubit.clearSubscriptionDates,
                style: TextButton.styleFrom(
                  foregroundColor: ColorPalette.primary,
                ),
                child: Text(
                  'مسح تواريخ الاشتراك',
                  style: AppTextStyle.font12PrimaryBoldTajawal(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
