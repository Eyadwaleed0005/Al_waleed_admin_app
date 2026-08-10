import 'package:alwaleed_admain/core/widgets/custom_delete_confirmation_bottom_sheet.dart';
import 'package:alwaleed_admain/features/live_session/domain/entities/live_session_entity.dart';
import 'package:alwaleed_admain/features/live_session/presentation/cubit/live_session_cubit.dart';
import 'package:alwaleed_admain/features/live_session/presentation/widgets/live_session_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveSessionSavedContent extends StatelessWidget {
  const LiveSessionSavedContent({
    super.key,
    required this.liveSession,
    required this.isDeleting,
  });

  final LiveSessionEntity liveSession;
  final bool isDeleting;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showCustomDeleteConfirmationBottomSheet(
      context,
      title: 'حذف رابط الحصة',
      message:
          'هل أنت متأكد من حذف رابط الحصة؟ لن يتمكن الطلاب من الانضمام إلى الحصة بعد الحذف.',
      confirmText: 'حذف الرابط',
    );

    if (!context.mounted || !confirmed) {
      return;
    }

    context.read<LiveSessionCubit>().deleteLiveSession();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: LiveSessionDetailsCard(
          liveSession: liveSession,
          isDeleting: isDeleting,
          onDelete: () {
            _confirmDelete(context);
          },
        ),
      ),
    );
  }
}
