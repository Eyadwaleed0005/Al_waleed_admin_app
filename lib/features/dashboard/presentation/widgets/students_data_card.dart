import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentsDataCard extends StatefulWidget {
  const StudentsDataCard({
    super.key,
    required this.studentsCount,
    required this.title,
    required this.numberColor,
    this.enableCountVisibility = true,
  });

  final int studentsCount;
  final String title;
  final Color numberColor;
  final bool enableCountVisibility;

  @override
  State<StudentsDataCard> createState() => _StudentsDataCardState();
}

class _StudentsDataCardState extends State<StudentsDataCard> {
  late bool _isCountVisible;

  @override
  void initState() {
    super.initState();
    _isCountVisible = !widget.enableCountVisibility;
  }

  void _toggleCountVisibility() {
    setState(() {
      _isCountVisible = !_isCountVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color eyeColor = ColorPalette.secondary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: ColorPalette.cardBackground,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: ColorPalette.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Text(
                      _isCountVisible ? widget.studentsCount.toString() : '•••',
                      key: ValueKey(_isCountVisible),
                      textDirection: TextDirection.ltr,
                      style: AppTextStyle.font20PrimarySemiBoldKufam().copyWith(
                        color: widget.numberColor,
                      ),
                    ),
                  ),
                  verticalSpace(8),
                  SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.right,
                        style: AppTextStyle.font12TextSecondaryRegularTajawal(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.enableCountVisibility) ...[
              horizontalSpace(8),
              GestureDetector(
                onTap: _toggleCountVisibility,
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: eyeColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: eyeColor.withValues(alpha: 0.12)),
                  ),
                  child: Icon(
                    _isCountVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: eyeColor,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
