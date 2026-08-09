import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/custom_filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopupSelectionItem<T> {
  const PopupSelectionItem({required this.value, required this.label});

  final T value;
  final String label;
}

class CustomPopupMenuField<T> extends StatelessWidget {
  const CustomPopupMenuField({
    super.key,
    required this.items,
    required this.value,
    required this.selectedText,
    required this.tooltip,
    required this.onSelected,
    this.emptyTooltip,
    this.labelText,
    this.filterValue,
    this.validator,
    this.enabled = true,
  });

  final List<PopupSelectionItem<T>> items;

  final T? value;

  final String selectedText;
  final String tooltip;
  final String? emptyTooltip;
  final String? labelText;
  final String? filterValue;

  final FormFieldValidator<T>? validator;
  final ValueChanged<T> onSelected;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final canOpen = enabled && items.isNotEmpty;

    return FormField<T>(
      key: ValueKey<T?>(value),
      initialValue: value,
      validator: validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PopupMenuButton<T>(
              enabled: canOpen,
              tooltip: canOpen ? tooltip : emptyTooltip ?? tooltip,
              position: PopupMenuPosition.under,
              color: ColorPalette.surface,
              surfaceTintColor: Colors.transparent,
              elevation: 4,
              offset: Offset(0, 4.h),
              initialValue: value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
                side: BorderSide(
                  color: field.hasError
                      ? ColorPalette.error
                      : ColorPalette.border,
                  width: 1.w,
                ),
              ),
              onSelected: (selectedValue) {
                field.didChange(selectedValue);
                onSelected(selectedValue);
              },
              itemBuilder: (context) {
                return items.map((item) {
                  return CheckedPopupMenuItem<T>(
                    value: item.value,
                    checked: item.value == value,
                    child: Text(
                      item.label,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: AppTextStyle.font15TextPrimaryMediumTajawal(),
                    ),
                  );
                }).toList();
              },
              child: IgnorePointer(
                child: CustomFilterButton(
                  labelText: labelText,
                  text: selectedText,
                  value: filterValue,
                ),
              ),
            ),
            if (field.hasError) ...[
              verticalSpace(6),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  field.errorText!,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyle.font12ErrorRegularTajawal(),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
