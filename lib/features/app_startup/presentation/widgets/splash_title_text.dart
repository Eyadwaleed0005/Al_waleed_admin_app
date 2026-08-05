import 'package:flutter/material.dart';

class SplashTitleText extends StatelessWidget {
  const SplashTitleText({
    super.key,
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      style: style,
    );
  }
}