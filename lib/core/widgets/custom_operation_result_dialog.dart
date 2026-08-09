import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/app_toast.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_secondary_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum CustomOperationResultType { success, failure }

class CustomOperationResultDialog extends StatefulWidget {
  const CustomOperationResultDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    required this.actionText,
    this.onActionPressed,
    this.email,
    this.password,
    this.successIcon = Icons.check_circle_outline_rounded,
    this.failureIcon = Icons.error_outline_rounded,
  });

  final CustomOperationResultType type;

  final String title;
  final String message;
  final String actionText;

  final String? email;
  final String? password;

  final VoidCallback? onActionPressed;

  final IconData successIcon;
  final IconData failureIcon;

  @override
  State<CustomOperationResultDialog> createState() {
    return _CustomOperationResultDialogState();
  }
}

class _CustomOperationResultDialogState
    extends State<CustomOperationResultDialog> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool get isSuccess {
    return widget.type == CustomOperationResultType.success;
  }

  bool get hasEmail {
    return isSuccess && widget.email != null && widget.email!.trim().isNotEmpty;
  }

  bool get hasPassword {
    return isSuccess && widget.password != null && widget.password!.isNotEmpty;
  }

  bool get hasCredentials {
    return hasEmail || hasPassword;
  }

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: widget.email?.trim() ?? '');

    _passwordController = TextEditingController(text: widget.password ?? '');
  }

  Future<void> _copyEmail() async {
    if (!hasEmail) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: _emailController.text));

    if (!mounted) {
      return;
    }

    showAppToast(
      context,
      message: 'تم نسخ البريد الإلكتروني',
      icon: Icons.copy_rounded,
    );
  }

  Future<void> _copyPassword() async {
    if (!hasPassword) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: _passwordController.text));

    if (!mounted) {
      return;
    }

    showAppToast(
      context,
      message: 'تم نسخ كلمة المرور',
      icon: Icons.copy_rounded,
    );
  }

  Future<void> _copyCredentials() async {
    final values = <String>[];

    if (hasEmail) {
      values.add('البريد الإلكتروني: ${_emailController.text}');
    }

    if (hasPassword) {
      values.add('كلمة المرور: ${_passwordController.text}');
    }

    if (values.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: values.join('\n')));

    if (!mounted) {
      return;
    }

    showAppToast(
      context,
      message: hasPassword
          ? 'تم نسخ بيانات تسجيل الدخول'
          : 'تم نسخ البريد الإلكتروني',
      icon: Icons.copy_all_rounded,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = isSuccess ? ColorPalette.success : ColorPalette.error;

    final icon = isSuccess ? widget.successIcon : widget.failureIcon;

    return AppAnimations.operationDialogEntrance(
      child: Dialog(
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            decoration: BoxDecoration(
              color: ColorPalette.surface,
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.30),
                width: 1.2.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.12),
                  blurRadius: 28.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 38.sp, color: statusColor),
                ),

                verticalSpace(22),

                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.font18TextPrimarySemiBoldKufam(),
                ),

                verticalSpace(10),

                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyle.font14TextSecondaryRegularTajawal(),
                ),

                if (hasCredentials) ...[
                  verticalSpace(24),

                  if (hasEmail)
                    CustomTextFormField(
                      controller: _emailController,
                      labelText: 'البريد الإلكتروني',
                      hintText: 'البريد الإلكتروني',
                      readOnly: true,
                      textDirection: TextDirection.ltr,
                      suffixIcon: Icon(
                        Icons.copy_rounded,
                        color: ColorPalette.primary,
                        size: 22.sp,
                      ),
                      onSuffixTap: _copyEmail,
                    ),

                  if (hasEmail && hasPassword) verticalSpace(12),

                  if (hasPassword)
                    CustomTextFormField(
                      controller: _passwordController,
                      labelText: 'كلمة المرور',
                      hintText: 'كلمة المرور',
                      readOnly: true,
                      isPassword: true,
                      textDirection: TextDirection.ltr,
                      suffixIcon: Icon(
                        Icons.copy_rounded,
                        color: ColorPalette.primary,
                        size: 22.sp,
                      ),
                      onSuffixTap: _copyPassword,
                    ),

                  verticalSpace(16),

                  CustomSecondaryButton(
                    text: hasPassword
                        ? 'نسخ بيانات الدخول'
                        : 'نسخ البريد الإلكتروني',
                    icon: Icons.copy_all_rounded,
                    onPressed: _copyCredentials,
                  ),
                ],

                verticalSpace(26),

                CustomButton(
                  text: widget.actionText,
                  onPressed:
                      widget.onActionPressed ??
                      () {
                        Navigator.of(context).pop();
                      },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
