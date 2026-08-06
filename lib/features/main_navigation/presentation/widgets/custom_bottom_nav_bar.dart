import 'package:alwaleed_admain/app/routes/route_nav_bottom.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/features/main_navigation/presentation/widgets/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final icons = RouteNavBottom.icons;
    final titles = RouteNavBottom.titles;

    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      child: Container(
        height: 64.h,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: ColorPalette.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: ColorPalette.border, width: 0.8.w),
          boxShadow: [
            BoxShadow(
              color: ColorPalette.primary.withValues(alpha: 0.08),
              blurRadius: 14.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          children: List.generate(icons.length, (index) {
            return Expanded(
              child: NavItem(
                iconPath: icons[index],
                title: titles[index],
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}
