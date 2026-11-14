import 'package:alwaleed_admin/core/widgets/custom_status_switch.dart';
import 'package:flutter/material.dart';

class StudyNoteAccessTypeSwitch extends StatelessWidget {
  const StudyNoteAccessTypeSwitch({
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
      activeText: 'مذكرة مدفوعة',
      inactiveText: 'مذكرة مجانية',
      activeSemanticLabel: 'مذكرة مدفوعة، تتطلب اشتراكًا نشطًا',
      inactiveSemanticLabel: 'مذكرة مجانية، متاحة لجميع طلاب الصف',
      activeTooltip: 'اضغط لجعل المذكرة مجانية',
      inactiveTooltip: 'اضغط لجعل المذكرة مدفوعة',
      activeIcon: Icons.attach_money_rounded,
      inactiveIcon: Icons.money_off_rounded,
    );
  }
}
