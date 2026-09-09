import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/app_refresh_indicator.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/exam_results_cubit.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/exam_results_screen_widgets/exam_results_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamResultsContent extends StatelessWidget {
  const ExamResultsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentManagementBackground(
        child: SafeArea(
          child: AppNetworkAwareContent(
            child: AppRefreshIndicator(
              onRefresh: () {
                return context.read<ExamResultsCubit>().refreshExamResults();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          AppAnimations.screenSection(
                            delay: 0,
                            child: const SecondaryCustomHeaderBar(
                              title: 'تقرير النتائج',
                            ),
                          ),
                          verticalSpace(30),
                        ],
                      ),
                    ),
                  ),
                  const ExamResultsStateView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
