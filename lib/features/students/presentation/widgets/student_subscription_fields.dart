import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/custom_date_picker_field.dart';
import 'package:alwaleed_admain/core/widgets/custom_form_field_error_text.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSubscriptionFields extends StatelessWidget {
  const StudentSubscriptionFields({super.key, required this.state});

  final AddStudentState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddStudentCubit>();

    return AppAnimations.formFieldEntrance(
      order: 6,
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FormField<DateTime>(
              key: ValueKey(
                'start-'
                '${state.subscriptionStartDate?.millisecondsSinceEpoch}',
              ),
              initialValue: state.subscriptionStartDate,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_) {
                return AppValidator.subscriptionStartDate(
                  state.subscriptionStartDate,
                );
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomDatePickerField(
                      controller: cubit.subscriptionStartDateController,
                      labelText: 'بداية الاشتراك',
                      hintText: 'اختر التاريخ',
                      selectedDate: state.subscriptionStartDate,
                      initialDate: state.subscriptionStartDate,
                      firstDate: cubit.today,
                      onDateSelected: (date) {
                        field.didChange(date);

                        cubit.selectSubscriptionStartDate(date);
                      },
                    ),

                    CustomFormFieldErrorText(errorText: field.errorText),
                  ],
                );
              },
            ),
          ),

          horizontalSpace(12),

          Expanded(
            child: FormField<DateTime>(
              key: ValueKey(
                'end-'
                '${state.subscriptionStartDate?.millisecondsSinceEpoch}-'
                '${state.subscriptionEndDate?.millisecondsSinceEpoch}',
              ),
              initialValue: state.subscriptionEndDate,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_) {
                return AppValidator.subscriptionEndDate(
                  startDate: state.subscriptionStartDate,
                  endDate: state.subscriptionEndDate,
                );
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomDatePickerField(
                      controller: cubit.subscriptionEndDateController,
                      labelText: 'نهاية الاشتراك',
                      hintText: 'اختر التاريخ',
                      selectedDate: state.subscriptionEndDate,
                      initialDate: state.subscriptionEndDate,
                      firstDate: cubit.subscriptionEndFirstDate,
                      onDateSelected: (date) {
                        field.didChange(date);

                        cubit.selectSubscriptionEndDate(date);
                      },
                    ),

                    CustomFormFieldErrorText(errorText: field.errorText),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
