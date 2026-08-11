import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';

class ContentSectionsTitle extends StatelessWidget {
  const ContentSectionsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'أقسام المحتوى',
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: AppTextStyle.font20TextPrimarySemiBoldKufam(),
      ),
    );
  }
}
