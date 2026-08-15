import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef LessonExamChoiceChanged = void Function(int index, String value);

class LessonExamQuestionChoicesFields extends StatelessWidget {
  const LessonExamQuestionChoicesFields({
    super.key,
    required this.choiceControllers,
    this.onChoiceChanged,
    this.enabled = true,
  }) : assert(
         choiceControllers.length == 4,
         'يجب تمرير أربعة Controllers للاختيارات',
       );

  final List<TextEditingController> choiceControllers;

  final LessonExamChoiceChanged? onChoiceChanged;

  final bool enabled;

  static const List<String> _choiceLabels = [
    'الاختيار الأول',
    'الاختيار الثاني',
    'الاختيار الثالث',
    'الاختيار الرابع',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: ColorPalette.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.black.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'اختيارات الإجابة',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font15TextPrimaryMediumTajawal(),
          ),

          verticalSpace(16),

          ...List.generate(choiceControllers.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == choiceControllers.length - 1 ? 0 : 16.h,
              ),
              child: CustomTextFormField(
                controller: choiceControllers[index],
                labelText: _choiceLabels[index],
                hintText: 'اكتب ${_choiceLabels[index]}',
                keyboardType: TextInputType.text,
                textInputAction: index == choiceControllers.length - 1
                    ? TextInputAction.done
                    : TextInputAction.next,
                maxLength: 200,
                enabled: enabled,
                validator: AppValidator.lessonExamQuestionChoice,
                onChanged: (value) {
                  onChoiceChanged?.call(index, value);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
