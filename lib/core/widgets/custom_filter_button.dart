import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFilterButton extends StatelessWidget {
  const CustomFilterButton({
    super.key,
    required this.text,
    this.value,
    this.labelText,
    this.onTap,
    this.validator,
    this.enabled = true,
  });

  final String text;
  final String? value;
  final String? labelText;

  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return FormField<String>(
      key: ValueKey<String>('${labelText ?? text}-${value ?? 'empty'}'),
      initialValue: value,
      validator: validator,
      builder: (fieldState) {
        final hasError = fieldState.hasError;

        final button = SizedBox(
          height: 56.h,
          child: Material(
            color: enabled ? ColorPalette.surface : ColorPalette.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
              side: BorderSide(
                color: hasError ? errorColor : ColorPalette.border,
                width: hasError ? 1.3.w : 1.w,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: enabled
                  ? () {
                      if (fieldState.hasError) {
                        fieldState.reset();
                      }

                      onTap?.call();
                    }
                  : null,
              splashColor: ColorPalette.primarySoftBackground,
              highlightColor: ColorPalette.primarySoftBackground,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: value == null
                            ? AppTextStyle.font15TextMutedRegularTajawal()
                            : AppTextStyle.font15TextPrimaryMediumTajawal(),
                      ),
                    ),
                    horizontalSpace(8),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 26.sp,
                      color: enabled
                          ? ColorPalette.textSecondary
                          : ColorPalette.divider,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (labelText != null && labelText!.trim().isNotEmpty) ...[
              Text(
                labelText!,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: AppTextStyle.font15TextPrimaryMediumTajawal(),
              ),
              verticalSpace(8),
            ],
            button,
            if (hasError) ...[
              verticalSpace(6),
              Text(
                fieldState.errorText!,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: AppTextStyle.font15TextMutedRegularTajawal().copyWith(
                  color: errorColor,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
