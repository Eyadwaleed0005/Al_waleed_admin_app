import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_secondary_button.dart';
import 'package:flutter/material.dart';

class LessonExamsActions extends StatelessWidget {
  const LessonExamsActions({
    super.key,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    this.isPrimaryLoading = false,
    this.isPrimaryEnabled = true,
    this.isSecondaryEnabled = true,
  });

  final String primaryButtonText;
  final String secondaryButtonText;

  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  final bool isPrimaryLoading;
  final bool isPrimaryEnabled;
  final bool isSecondaryEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: CustomButton(
            text: primaryButtonText,
            isLoading: isPrimaryLoading,
            isEnabled: isPrimaryEnabled,
            onPressed: onPrimaryPressed,
          ),
        ),

        horizontalSpace(12),

        Expanded(
          child: CustomSecondaryButton(
            text: secondaryButtonText,
            isEnabled: isSecondaryEnabled,
            onPressed: onSecondaryPressed,
          ),
        ),
      ],
    );
  }
}
