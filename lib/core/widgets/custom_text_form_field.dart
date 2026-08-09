import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.suffixIcon,
    this.onSuffixTap,
    this.suffixTooltip,
    this.isPassword = false,
    this.showPasswordCopyIcon = true,
    this.isRequired = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.textDirection = TextDirection.rtl,
    this.autofillHints,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final TextEditingController controller;
  final String hintText;
  final String? labelText;

  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final List<TextInputFormatter>? inputFormatters;

  final FormFieldValidator<String>? validator;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final VoidCallback? onTap;

  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? suffixTooltip;

  final bool isPassword;
  final bool showPasswordCopyIcon;
  final bool isRequired;
  final bool enabled;
  final bool readOnly;

  final int maxLines;
  final int? minLines;
  final int? maxLength;

  final TextDirection textDirection;

  final Iterable<String>? autofillHints;

  final AutovalidateMode autovalidateMode;

  @override
  State<CustomTextFormField> createState() {
    return _CustomTextFormFieldState();
  }
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();

  bool _skipNextValidation = false;

  OutlineInputBorder _buildBorder({
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.r),
      borderSide: BorderSide(color: color, width: width.w),
    );
  }

  String? _validate(String? value) {
    if (_skipNextValidation) {
      _skipNextValidation = false;
      return null;
    }

    final text = value?.trim() ?? '';

    if (widget.isRequired && text.isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    return widget.validator?.call(value);
  }

  void _clearValidationError() {
    final fieldState = _fieldKey.currentState;

    if (fieldState == null || !fieldState.hasError) {
      return;
    }

    _skipNextValidation = true;
    fieldState.validate();
  }

  void _handleTap() {
    _clearValidationError();
    widget.onTap?.call();
  }

  void _handleChanged(String value) {
    _clearValidationError();
    widget.onChanged?.call(value);
  }

  Future<void> _copyText() async {
    final text = widget.controller.text;

    if (text.isEmpty) {
      showAppToast(
        context,
        message: 'لا يوجد نص لنسخه',
        icon: Icons.info_outline_rounded,
      );

      return;
    }

    await Clipboard.setData(ClipboardData(text: text));

    if (!mounted) {
      return;
    }

    showAppToast(
      context,
      message: 'تم النسخ بنجاح',
      icon: Icons.check_circle_rounded,
    );
  }

  Widget? _buildSuffixIcon() {
    Widget? icon;
    VoidCallback? onTap;
    String? tooltipMessage;

    if (widget.suffixIcon != null) {
      icon = widget.suffixIcon;

      onTap = widget.onSuffixTap ?? (widget.isPassword ? _copyText : null);

      tooltipMessage = widget.suffixTooltip;
    } else if (widget.isPassword && widget.showPasswordCopyIcon) {
      icon = Icon(
        Icons.copy_rounded,
        color: ColorPalette.textPrimary,
        size: 23.sp,
      );

      onTap = widget.onSuffixTap ?? _copyText;

      tooltipMessage = widget.suffixTooltip ?? 'نسخ كلمة المرور';
    }

    if (icon == null) {
      return null;
    }

    Widget suffixWidget;

    if (onTap == null) {
      suffixWidget = Padding(padding: EdgeInsets.all(16.r), child: icon);
    } else {
      suffixWidget = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        splashColor: ColorPalette.primarySoftBackground,
        highlightColor: ColorPalette.primarySoftBackground,
        child: Padding(padding: EdgeInsets.all(16.r), child: icon),
      );
    }

    if (tooltipMessage == null) {
      return suffixWidget;
    }

    return Tooltip(message: tooltipMessage, child: suffixWidget);
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

    final errorColor = currentTheme.colorScheme.error;

    final textField = Theme(
      data: currentTheme.copyWith(
        colorScheme: currentTheme.colorScheme.copyWith(
          primary: ColorPalette.primary,
          surface: ColorPalette.surface,
          onSurface: ColorPalette.textPrimary,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ColorPalette.primary,
          selectionColor: ColorPalette.accent.withValues(alpha: 0.45),
          selectionHandleColor: ColorPalette.primary,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          key: _fieldKey,
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          textAlign: TextAlign.right,
          textDirection: widget.textDirection,
          cursorColor: ColorPalette.primary,
          obscureText: false,
          autofillHints: widget.autofillHints,
          autovalidateMode: widget.autovalidateMode,
          style: AppTextStyle.font15TextPrimaryMediumTajawal(),
          validator: _validate,
          onTap: _handleTap,
          onChanged: _handleChanged,
          onFieldSubmitted: widget.onSubmitted,
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
            hintText: widget.hintText,
            hintStyle: AppTextStyle.font15TextMutedRegularTajawal(),
            filled: true,
            fillColor: ColorPalette.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 17.h,
            ),
            suffixIcon: _buildSuffixIcon(),
            suffixIconConstraints: BoxConstraints(
              minWidth: 56.w,
              minHeight: 56.h,
              maxWidth: 56.w,
              maxHeight: 56.h,
            ),
            enabledBorder: _buildBorder(color: ColorPalette.border, width: 1),
            focusedBorder: _buildBorder(
              color: ColorPalette.primary,
              width: 1.3,
            ),
            disabledBorder: _buildBorder(color: ColorPalette.divider, width: 1),
            errorBorder: _buildBorder(color: errorColor, width: 1),
            focusedErrorBorder: _buildBorder(color: errorColor, width: 1.3),
          ),
        ),
      ),
    );

    if (widget.labelText == null || widget.labelText!.trim().isEmpty) {
      return textField;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.labelText!,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: AppTextStyle.font15TextPrimaryMediumTajawal(),
        ),

        verticalSpace(8),

        textField,
      ],
    );
  }
}
