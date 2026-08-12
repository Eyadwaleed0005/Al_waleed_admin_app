import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class AddNoteDescriptionField extends StatelessWidget {
  const AddNoteDescriptionField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      focusNode: focusNode,
      labelText: 'وصف المذكرة',
      hintText: 'أدخل وصفًا مختصرًا للمذكرة',
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: 4,
      maxLines: 6,
      isRequired: true,
      onChanged: onChanged,
    );
  }
}