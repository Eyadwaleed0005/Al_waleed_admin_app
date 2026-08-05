import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHeaderBar extends StatelessWidget {
  const CustomHeaderBar({
    super.key,
    required this.title,
    required this.iconPath,
  });

  final String title;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: Textstyles.font18TextPrimarySemiBoldKufam(),
          ),
        ),
        Image.asset(iconPath, width: 24.w, height: 24.h, fit: BoxFit.contain),
      ],
    );
  }
}
