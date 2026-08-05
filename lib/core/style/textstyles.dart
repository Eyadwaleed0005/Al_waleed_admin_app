import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/fontweighthelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Textstyles {
  static const String tajawal = 'Tajawal';
  static const String kufam = 'Kufam';


  static TextStyle font20HighlightSemiBoldKufam() {
    return TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: kufam,
      color: ColorPalette.highlight,
    );
  }
  static TextStyle font14AccentRegularTajawal() {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeightHelper.regular,
      fontFamily: tajawal,
      color: ColorPalette.accent,
    );
  }

  static TextStyle font18TextPrimarySemiBoldKufam() {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: kufam,
      color: ColorPalette.textPrimary,
    );
  }

  static TextStyle font12DeepSurfaceMediumTajawal() {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeightHelper.medium,
      fontFamily: tajawal,
      color: ColorPalette.deepSurface,
    );
  } 
  static TextStyle font26HighlightBoldKufam() {
    return TextStyle(
      fontSize: 26.sp,
      fontWeight: FontWeightHelper.bold,
      fontFamily: kufam,
      color: ColorPalette.highlight,
    );
  } 
   static TextStyle font13AccentRegularTajawal() {
    return TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeightHelper.regular,
      fontFamily: tajawal,
      color: ColorPalette.accent,
    );
  } 
}
