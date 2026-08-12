import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class AddNoteDescriptionField extends StatelessWidget {
  const AddNoteDescriptionField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      labelText: 'وصف المذكرة',
      hintText: 'اكتب وصفًا مختصرًا للمذكرة',
      isRequired: true,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: 3,
      maxLines: 5,
      onChanged: onChanged,
    );
  }
}