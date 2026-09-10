import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamDurationField extends StatelessWidget {
  const ExamDurationField({
    super.key,
    required this.controller,
    required this.validator,
    this.onChanged,
  });

  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      labelText: 'مدة الاختبار بالدقائق',
      hintText: 'مثال: ٦٠',
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      validator: validator,
      onChanged: onChanged,
      suffixIcon: Icon(
        Icons.timer_outlined,
        color: ColorPalette.primary,
        size: 22.sp,
      ),
      suffixTooltip: 'مدة الاختبار بالدقائق',
    );
  }
}