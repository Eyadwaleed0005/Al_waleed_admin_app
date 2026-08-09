import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondaryCustomHeaderBar extends StatelessWidget {
  const SecondaryCustomHeaderBar({
    required this.title,
    this.onBackPressed,
    super.key,
  });

  final String title;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: AppTextStyle.font18PrimarySemiBoldKufam(),
          ),
        ),
        horizontalSpace(12),
        IconButton(
          onPressed:
              onBackPressed ??
              () {
                Navigator.of(context).maybePop();
              },
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: 40.w,
            minHeight: 40.h,
          ),
          tooltip: 'رجوع',
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22.sp,
          ),
        ),
      ],
    );
  }
}