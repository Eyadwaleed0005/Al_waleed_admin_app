import 'package:alwaleed_admain/app/routes/app_images_routes.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.controller,
    this.hintText = 'البحث بالاسم أو رقم الهاتف',
    this.onChanged,
    this.onSubmitted,
    this.onSearchTap,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSearchTap;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

    return Theme(
      data: currentTheme.copyWith(
        colorScheme: currentTheme.colorScheme.copyWith(
          primary: ColorPalette.primary,
          surface: ColorPalette.surface,
          onSurface: ColorPalette.textPrimary,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ColorPalette.primary,
          selectionColor: ColorPalette.accent.withOpacity(0.45),
          selectionHandleColor: ColorPalette.primary,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.left,
          cursorColor: ColorPalette.primary,
          style: AppTextStyle.font15TextPrimaryMediumTajawal(),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          contextMenuBuilder: (context, editableTextState) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: ColorPalette.primary,
                  surface: ColorPalette.surface,
                  onSurface: ColorPalette.textPrimary,
                ),
              ),
              child: AdaptiveTextSelectionToolbar.buttonItems(
                anchors: editableTextState.contextMenuAnchors,
                buttonItems: editableTextState.contextMenuButtonItems,
              ),
            );
          },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyle.font15TextMutedRegularTajawal(),
            filled: true,
            fillColor: ColorPalette.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 17.h,
            ),
            suffixIcon: InkWell(
              onTap: onSearchTap,
              borderRadius: BorderRadius.circular(18.r),
              splashColor: ColorPalette.primarySoftBackground,
              highlightColor: ColorPalette.primarySoftBackground,
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Image.asset(
                  AppImage().search,
                  width: 24.w,
                  height: 24.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            suffixIconConstraints: BoxConstraints(
              minWidth: 56.w,
              minHeight: 56.h,
              maxWidth: 56.w,
              maxHeight: 56.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(color: ColorPalette.border, width: 1.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(color: ColorPalette.primary, width: 1.3.w),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(color: ColorPalette.divider, width: 1.w),
            ),
          ),
        ),
      ),
    );
  }
}
