import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDatePickerField extends StatelessWidget {
  const CustomDatePickerField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onDateSelected,
    this.labelText,
    this.selectedDate,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.isRequired = false,
    this.enabled = true,
  });

  final TextEditingController controller;

  final String hintText;
  final String? labelText;

  final DateTime? selectedDate;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  final ValueChanged<DateTime> onDateSelected;

  final FormFieldValidator<String>? validator;

  final bool isRequired;
  final bool enabled;

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _getInitialDate({required DateTime first, required DateTime last}) {
    final date = _normalizeDate(selectedDate ?? initialDate ?? DateTime.now());

    if (date.isBefore(first)) {
      return first;
    }

    if (date.isAfter(last)) {
      return last;
    }

    return date;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');

    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Future<void> _openDatePicker(BuildContext context) async {
    if (!enabled) {
      return;
    }

    final normalizedFirstDate = _normalizeDate(firstDate ?? DateTime(2000));

    final normalizedLastDate = _normalizeDate(lastDate ?? DateTime(2100));

    final pickerInitialDate = _getInitialDate(
      first: normalizedFirstDate,
      last: normalizedLastDate,
    );

    final selected = await showDatePicker(
      context: context,
      initialDate: pickerInitialDate,
      firstDate: normalizedFirstDate,
      lastDate: normalizedLastDate,
      helpText: labelText ?? 'اختر التاريخ',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
      barrierColor: ColorPalette.deepSurface.withValues(alpha: 0.45),
      builder: (context, child) {
        final currentTheme = Theme.of(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Theme(
            data: currentTheme.copyWith(
              disabledColor: ColorPalette.disabled,
              dividerColor: ColorPalette.divider,
              colorScheme: currentTheme.colorScheme.copyWith(
                primary: ColorPalette.primary,
                onPrimary: ColorPalette.surface,
                secondary: ColorPalette.accent,
                onSecondary: ColorPalette.textPrimary,
                surface: ColorPalette.surface,
                onSurface: ColorPalette.textPrimary,
                error: ColorPalette.error,
                outline: ColorPalette.border,
              ),
              datePickerTheme: DatePickerThemeData(
                backgroundColor: ColorPalette.surface,
                surfaceTintColor: ColorPalette.surface.withValues(alpha: 0),
                shadowColor: ColorPalette.primaryPressed.withValues(
                  alpha: 0.14,
                ),
                elevation: 8,
                dividerColor: ColorPalette.divider,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  side: BorderSide(color: ColorPalette.border, width: 1.w),
                ),

                headerBackgroundColor: ColorPalette.primary,
                headerForegroundColor: ColorPalette.surface,
                headerHeadlineStyle: AppTextStyle.font18PrimarySemiBoldKufam()
                    .copyWith(color: ColorPalette.surface, fontSize: 22.sp),
                headerHelpStyle: AppTextStyle.font14TextPrimaryRegularTajawal()
                    .copyWith(color: ColorPalette.surface),

                weekdayStyle: AppTextStyle.font15TextMutedRegularTajawal()
                    .copyWith(color: ColorPalette.textSecondary),

                dayStyle: AppTextStyle.font15TextPrimaryMediumTajawal(),

                dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((
                  states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return ColorPalette.primary;
                  }

                  return null;
                }),

                dayForegroundColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return ColorPalette.surface;
                  }

                  if (states.contains(WidgetState.disabled)) {
                    return ColorPalette.disabled;
                  }

                  return ColorPalette.textPrimary;
                }),

                dayOverlayColor: WidgetStateProperty.resolveWith<Color?>((
                  states,
                ) {
                  if (states.contains(WidgetState.pressed) ||
                      states.contains(WidgetState.hovered) ||
                      states.contains(WidgetState.focused)) {
                    return ColorPalette.primarySoftBackground;
                  }

                  return null;
                }),

                dayShape: WidgetStateProperty.all<OutlinedBorder>(
                  const CircleBorder(),
                ),

                todayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((
                  states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return ColorPalette.primary;
                  }

                  return ColorPalette.primarySoftBackground;
                }),

                todayForegroundColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return ColorPalette.surface;
                  }

                  return ColorPalette.primary;
                }),

                todayBorder: BorderSide(
                  color: ColorPalette.primary,
                  width: 1.2.w,
                ),

                yearStyle: AppTextStyle.font15TextPrimaryMediumTajawal(),

                yearBackgroundColor: WidgetStateProperty.resolveWith<Color?>((
                  states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return ColorPalette.primary;
                  }

                  return null;
                }),

                yearForegroundColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return ColorPalette.surface;
                  }

                  if (states.contains(WidgetState.disabled)) {
                    return ColorPalette.disabled;
                  }

                  return ColorPalette.textPrimary;
                }),

                yearOverlayColor: WidgetStateProperty.resolveWith<Color?>((
                  states,
                ) {
                  if (states.contains(WidgetState.pressed) ||
                      states.contains(WidgetState.hovered) ||
                      states.contains(WidgetState.focused)) {
                    return ColorPalette.primarySoftBackground;
                  }

                  return null;
                }),

                yearShape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),

                cancelButtonStyle: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                    ColorPalette.textSecondary,
                  ),
                  overlayColor: WidgetStateProperty.all(
                    ColorPalette.primarySoftBackground,
                  ),
                ),

                confirmButtonStyle: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                    ColorPalette.primary,
                  ),
                  overlayColor: WidgetStateProperty.all(
                    ColorPalette.primarySoftBackground,
                  ),
                ),

                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: ColorPalette.primarySoftBackground,
                  hintStyle: AppTextStyle.font15TextMutedRegularTajawal(),
                  labelStyle: AppTextStyle.font15TextPrimaryMediumTajawal(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: ColorPalette.border,
                      width: 1.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: ColorPalette.primary,
                      width: 1.3.w,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: ColorPalette.error,
                      width: 1.w,
                    ),
                  ),
                ),
              ),
            ),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );

    if (selected == null) {
      return;
    }

    final normalizedSelectedDate = _normalizeDate(selected);

    controller.text = _formatDate(normalizedSelectedDate);

    onDateSelected(normalizedSelectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      isRequired: isRequired,
      enabled: enabled,
      readOnly: true,
      validator: validator,
      onTap: () {
        _openDatePicker(context);
      },
      suffixIcon: Icon(
        Icons.calendar_month_outlined,
        color: enabled ? ColorPalette.primary : ColorPalette.disabled,
        size: 24.sp,
      ),
      onSuffixTap: () {
        _openDatePicker(context);
      },
    );
  }
}
