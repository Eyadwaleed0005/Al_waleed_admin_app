import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class AddNoteTitleField extends StatelessWidget {
  const AddNoteTitleField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      focusNode: focusNode,
      labelText: 'عنوان المذكرة',
      hintText: 'أدخل عنوان المذكرة',
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      isRequired: true,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}