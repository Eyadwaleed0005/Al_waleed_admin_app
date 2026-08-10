import 'package:alwaleed_admain/app/routes/app_images_routes.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/widgets/custom_header_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentManagementSkeleton extends StatefulWidget {
  const StudentManagementSkeleton({super.key});

  @override
  State<StudentManagementSkeleton> createState() {
    return _StudentManagementSkeletonState();
  }
}

class _StudentManagementSkeletonState
    extends State<StudentManagementSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 20.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomHeaderBar(
            title: 'إدارة الطلاب',
            iconPath: AppImage().profileIcon,
          ),

          verticalSpace(32),

          Expanded(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Search bar skeleton
                      _buildSkeletonBox(
                        height: 64.h,
                        borderRadius: BorderRadius.circular(16.r),
                      ),

                      verticalSpace(16),

                      // Filters skeleton
                      Row(
                        children: [
                          Expanded(
                            child: _buildSkeletonBox(
                              height: 64.h,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),

                          horizontalSpace(16),

                          Expanded(
                            child: _buildSkeletonBox(
                              height: 64.h,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                        ],
                      ),

                      verticalSpace(40),

                      // Students cards skeleton
                      ...List.generate(3, (index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: _buildStudentCardSkeleton(),
                        );
                      }),

                      verticalSpace(4),

                      // Add student button skeleton
                      _buildSkeletonBox(
                        height: 56.h,
                        borderRadius: BorderRadius.circular(16.r),
                      ),

                      verticalSpace(20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCardSkeleton() {
    return Container(
      width: double.infinity,
      height: 106.h,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildSkeletonBox(
                  width: 145.w,
                  height: 20.h,
                  borderRadius: BorderRadius.circular(6.r),
                ),

                verticalSpace(12),

                _buildSkeletonBox(
                  width: 110.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ],
            ),
          ),

          horizontalSpace(16),

          _buildSkeletonBox(
            width: 58.w,
            height: 30.h,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonBox({
    double? width,
    required double height,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.rectangle,
  }) {
    final movement = _animationController.value * 3;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? borderRadius ?? BorderRadius.circular(8.r)
            : null,
        gradient: LinearGradient(
          begin: Alignment(-1.5 + movement, 0),
          end: Alignment(-0.5 + movement, 0),
          colors: const [
            Color(0xFFE0E7E2),
            Color(0xFFF4F7F5),
            Color(0xFFE0E7E2),
          ],
          stops: const [0.2, 0.5, 0.8],
        ),
      ),
    );
  }
}