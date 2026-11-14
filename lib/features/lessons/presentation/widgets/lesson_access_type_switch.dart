import 'package:alwaleed_admin/core/widgets/custom_status_switch.dart';
import 'package:flutter/material.dart';

class LessonAccessTypeSwitch extends StatelessWidget {
  const LessonAccessTypeSwitch({
    super.key,
    required this.isFree,
    required this.onChanged,
    this.enabled = true,
  });

  final bool isFree;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CustomStatusSwitch(
      value: !isFree,
      onChanged: enabled
          ? (isPaid) {
              onChanged(!isPaid);
            }
          : null,
      activeText: 'درس مدفوع',
      inactiveText: 'درس مجاني',
      activeSemanticLabel: 'درس مدفوع، يتطلب اشتراكًا نشطًا',
      inactiveSemanticLabel: 'درس مجاني، متاح لجميع طلاب الصف',
      activeTooltip: 'اضغط لجعل الدرس مجانيًا',
      inactiveTooltip: 'اضغط لجعل الدرس مدفوعًا',
      activeIcon: Icons.attach_money_rounded,
      inactiveIcon: Icons.money_off_rounded,
    );
  }
}
