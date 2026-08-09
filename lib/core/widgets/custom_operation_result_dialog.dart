import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/app_toast.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
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

  bool get isSuccess {
    return type == CustomOperationResultType.success;
  }

  bool get hasCredentials {
    return isSuccess &&
        email != null &&
        email!.trim().isNotEmpty &&
        password != null &&
        password!.isNotEmpty;
  }

  @override
  State<CustomOperationResultDialog> createState() {
    return _CustomOperationResultDialogState();
  }
}

class _CustomOperationResultDialogState
    extends State<CustomOperationResultDialog> {
  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: widget.email?.trim() ?? '');

    _passwordController = TextEditingController(text: widget.password ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _copyCredentials() async {
    if (!widget.hasCredentials) {
      return;
    }

    final credentials =
        'البريد الإلكتروني: '
        '${_emailController.text.trim()}\n'
        'كلمة المرور: '
        '${_passwordController.text}';

    await Clipboard.setData(ClipboardData(text: credentials));

    if (!mounted) {
      return;
    }

    showAppToast(
      context,
      message: 'تم نسخ بيانات تسجيل الدخول',
      icon: Icons.copy_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = widget.isSuccess
        ? ColorPalette.success
        : ColorPalette.error;

    final icon = widget.isSuccess ? widget.successIcon : widget.failureIcon;

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
                  style: AppTextStyle.font18PrimarySemiBoldKufam().copyWith(
                    color: ColorPalette.textPrimary,
                  ),
                ),

                verticalSpace(10),

                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.font14TextPrimaryRegularTajawal()
                      .copyWith(color: ColorPalette.textSecondary),
                ),

                if (widget.hasCredentials) ...[
                  verticalSpace(24),

                  AppAnimations.formFieldEntrance(
                    order: 0,
                    child: CustomTextFormField(
                      controller: _emailController,
                      labelText: 'البريد الإلكتروني',
                      hintText: 'البريد الإلكتروني',
                      readOnly: true,
                      textDirection: TextDirection.ltr,
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: Icon(
                        Icons.copy_rounded,
                        size: 22.sp,
                        color: ColorPalette.textPrimary,
                      ),
                      onSuffixTap: () async {
                        await Clipboard.setData(
                          ClipboardData(text: _emailController.text.trim()),
                        );

                        if (!mounted) {
                          return;
                        }

                        showAppToast(
                          context,
                          message: 'تم نسخ البريد الإلكتروني',
                          icon: Icons.check_circle_rounded,
                        );
                      },
                    ),
                  ),

                  verticalSpace(16),

                  AppAnimations.formFieldEntrance(
                    order: 1,
                    child: CustomTextFormField(
                      controller: _passwordController,
                      labelText: 'كلمة المرور',
                      hintText: 'كلمة المرور',
                      readOnly: true,
                      isPassword: true,
                      textDirection: TextDirection.ltr,
                    ),
                  ),

                  verticalSpace(18),

                  AppAnimations.formFieldEntrance(
                    order: 2,
                    child: SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: OutlinedButton.icon(
                        onPressed: _copyCredentials,
                        icon: Icon(Icons.copy_all_rounded, size: 21.sp),
                        label: Text(
                          'نسخ بيانات الدخول',
                          style: AppTextStyle.font15TextPrimaryMediumTajawal(),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorPalette.primary,
                          side: BorderSide(
                            color: ColorPalette.primary,
                            width: 1.2.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                      ),
                    ),
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
