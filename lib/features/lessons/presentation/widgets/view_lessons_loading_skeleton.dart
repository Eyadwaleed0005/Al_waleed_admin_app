import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewLessonsLoadingSkeleton extends StatefulWidget {
  const ViewLessonsLoadingSkeleton({super.key});

  @override
  State<ViewLessonsLoadingSkeleton> createState() {
    return _ViewLessonsLoadingSkeletonState();
  }
}

class _ViewLessonsLoadingSkeletonState extends State<ViewLessonsLoadingSkeleton>
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSkeletonBox(
              height: 56.h,
              borderRadius: BorderRadius.circular(16.r),
            ),
            verticalSpace(16),
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: _buildSkeletonBox(
                    height: 52.h,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                horizontalSpace(16),
                Expanded(
                  child: _buildSkeletonBox(
                    height: 52.h,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ],
            ),
            verticalSpace(24),
            Expanded(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                separatorBuilder: (_, _) {
                  return verticalSpace(12);
                },
                itemBuilder: (_, _) {
                  return _buildLessonCardSkeleton();
                },
              ),
            ),
            verticalSpace(16),
            _buildSkeletonBox(
              height: 56.h,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLessonCardSkeleton() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 116.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: ColorPalette.border, width: 1.w),
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
                FractionallySizedBox(
                  widthFactor: 0.62,
                  alignment: Alignment.centerRight,
                  child: _buildSkeletonBox(
                    height: 18.h,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                verticalSpace(12),
                FractionallySizedBox(
                  widthFactor: 0.92,
                  alignment: Alignment.centerRight,
                  child: _buildSkeletonBox(
                    height: 12.h,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                verticalSpace(8),
                FractionallySizedBox(
                  widthFactor: 0.72,
                  alignment: Alignment.centerRight,
                  child: _buildSkeletonBox(
                    height: 12.h,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(12),
          _buildSkeletonBox(
            width: 78.w,
            height: 34.h,
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
