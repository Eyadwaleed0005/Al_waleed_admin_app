import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomStatusSwitch extends StatelessWidget {
  const CustomStatusSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.activeText,
    required this.inactiveText,
    this.activeSemanticLabel,
    this.inactiveSemanticLabel,
    this.activeTooltip,
    this.inactiveTooltip,
    this.activeIcon = Icons.sentiment_satisfied_alt_rounded,
    this.inactiveIcon = Icons.sentiment_dissatisfied_rounded,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  final String activeText;
  final String inactiveText;

  final String? activeSemanticLabel;
  final String? inactiveSemanticLabel;

  final String? activeTooltip;
  final String? inactiveTooltip;

  final IconData activeIcon;
  final IconData inactiveIcon;

  bool get _isEnabled => onChanged != null;

  void _toggle() {
    onChanged?.call(!value);
  }

  @override
  Widget build(BuildContext context) {
    final displayedText = value ? activeText : inactiveText;

    final semanticLabel = value
        ? activeSemanticLabel ?? activeText
        : inactiveSemanticLabel ?? inactiveText;

    final tooltipMessage = value
        ? activeTooltip ?? semanticLabel
        : inactiveTooltip ?? semanticLabel;

    return Semantics(
      button: true,
      enabled: _isEnabled,
      toggled: value,
      label: semanticLabel,
      onTap: _isEnabled ? _toggle : null,
      child: ExcludeSemantics(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isEnabled ? 1 : 0.5,
          child: Tooltip(
            message: tooltipMessage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              height: 56.h,
              decoration: BoxDecoration(
                color: value
                    ? ColorPalette.primarySoftBackground
                    : ColorPalette.surface,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: value ? ColorPalette.accent : ColorPalette.border,
                  width: 1.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorPalette.black.withValues(alpha: 0.06),
                    blurRadius: 8.r,
                    offset: Offset(0, 3.h),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(18.r),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _isEnabled ? _toggle : null,
                  borderRadius: BorderRadius.circular(18.r),
                  splashColor: ColorPalette.primarySoftBackground,
                  highlightColor: ColorPalette.primarySoftBackground,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              displayedText,
                              key: ValueKey<String>(displayedText),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style:
                                  AppTextStyle.font15TextPrimaryMediumTajawal()
                                      .copyWith(
                                        color: value
                                            ? ColorPalette.primary
                                            : ColorPalette.black,
                                      ),
                            ),
                          ),
                        ),
                        horizontalSpace(8),
                        _StatusSwitchIndicator(
                          value: value,
                          activeIcon: activeIcon,
                          inactiveIcon: inactiveIcon,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusSwitchIndicator extends StatelessWidget {
  const _StatusSwitchIndicator({
    required this.value,
    required this.activeIcon,
    required this.inactiveIcon,
  });

  final bool value;
  final IconData activeIcon;
  final IconData inactiveIcon;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      width: 56.w,
      height: 34.h,
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: value ? ColorPalette.primary : ColorPalette.disabled,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: value ? ColorPalette.accent : ColorPalette.border,
          width: 1.w,
        ),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 26.w,
          height: 26.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: value ? ColorPalette.highlight : ColorPalette.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ColorPalette.black.withValues(alpha: 0.12),
                blurRadius: 3.r,
                offset: Offset(0, 1.h),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Icon(
              value ? activeIcon : inactiveIcon,
              key: ValueKey<bool>(value),
              size: 19.sp,
              color: value ? ColorPalette.primary : ColorPalette.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
