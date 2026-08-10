import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/features/live_session/domain/entities/meeting_type.dart';
import 'package:alwaleed_admain/features/live_session/presentation/widgets/meeting_type_item.dart';
import 'package:flutter/material.dart';

class MeetingTypeSelector extends StatelessWidget {
  const MeetingTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  final MeetingType? selectedType;
  final ValueChanged<MeetingType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: MeetingTypeItem(
            title: 'Google Meet',
            icon: Icons.video_call_outlined,
            isSelected: selectedType == MeetingType.googleMeet,
            onTap: () {
              onChanged(MeetingType.googleMeet);
            },
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: MeetingTypeItem(
            title: 'Zoom',
            icon: Icons.videocam_outlined,
            isSelected: selectedType == MeetingType.zoom,
            onTap: () {
              onChanged(MeetingType.zoom);
            },
          ),
        ),
      ],
    );
  }
}
