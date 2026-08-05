import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AppSystemUi {
  static SystemUiOverlayStyle dark() =>
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // iOS
      );

  static SystemUiOverlayStyle light() =>
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark, // iOS
      );
}
