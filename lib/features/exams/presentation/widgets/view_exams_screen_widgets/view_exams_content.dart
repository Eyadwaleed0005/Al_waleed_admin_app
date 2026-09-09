import 'package:alwaleed_admain/app/routes/app_images_routes.dart';
import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_header_bar.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/view_exams_cubit.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/view_exams_state.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/view_exams_screen_widgets/view_exams_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewExamsContent extends StatelessWidget {
  const ViewExamsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentManagementBackground(
        child: SafeArea(
          child: AppNetworkAwareContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
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
                                child: CustomHeaderBar(
                                  title: 'إدارة الاختبارات',
                                  iconPath: AppImage().profileIcon,
                                ),
                              ),
                              verticalSpace(30),
                            ],
                          ),
                        ),
                      ),
                      const ViewExamsStateView(),
                    ],
                  ),
                ),
                _buildFixedAddButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFixedAddButton(BuildContext context) {
    return BlocSelector<ViewExamsCubit, ViewExamsState, bool>(
      selector: (ViewExamsState state) {
        return state is ViewExamsEmpty || state is ViewExamsSuccess;
      },
      builder: (BuildContext context, bool shouldShowButton) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: shouldShowButton
              ? Container(
                  key: const ValueKey<String>('add-exam-button'),
                  padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 20.h),
                  child: AppAnimations.screenSection(
                    delay: 360,
                    child: CustomButton(
                      text: 'إنشاء اختبار جديد',
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamed(RouteNames.addExamScreen);
                      },
                    ),
                  ),
                )
              : const SizedBox.shrink(
                  key: ValueKey<String>('hidden-add-exam-button'),
                ),
        );
      },
    );
  }
}
