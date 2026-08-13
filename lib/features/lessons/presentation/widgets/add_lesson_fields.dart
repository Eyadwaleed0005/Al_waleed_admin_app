import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class AddLessonTitleField extends StatelessWidget {
  const AddLessonTitleField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.enabled = true,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      labelText: 'عنوان الدرس',
      hintText: 'أدخل عنوان الدرس',
      enabled: enabled,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: AppValidator.lessonTitle,
      onChanged: onChanged,
    );
  }
}

class AddLessonSubtitleField
    extends StatelessWidget {
  const AddLessonSubtitleField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.enabled = true,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      labelText: 'وصف الدرس',
      hintText: 'أدخل وصفًا مختصرًا للدرس',
      enabled: enabled,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: 3,
      maxLines: 4,
      validator: AppValidator.lessonSubtitle,
      onChanged: onChanged,
    );
  }
}


class AddLessonYoutubeUrlField
    extends StatelessWidget {
  const AddLessonYoutubeUrlField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.enabled = true,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      labelText: 'رابط فيديو YouTube',
      hintText:
          'https://www.youtube.com/watch?v=...',
      enabled: enabled,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      textDirection: TextDirection.ltr,
      autofillHints: const [
        AutofillHints.url,
      ],
      validator: AppValidator.youtubeUrl,
      onChanged: onChanged,
    );
  }
}