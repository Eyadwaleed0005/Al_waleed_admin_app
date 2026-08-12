import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNoteLoadingSkeleton extends StatefulWidget {
  const AddNoteLoadingSkeleton({super.key});

  @override
  State<AddNoteLoadingSkeleton> createState() {
    return _AddNoteLoadingSkeletonState();
  }
}

class _AddNoteLoadingSkeletonState extends State<AddNoteLoadingSkeleton>
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
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hint card
                    _buildSkeletonBox(
                      height: 80.h,
                      borderRadius: BorderRadius.circular(18.r),
                    ),

                    verticalSpace(24),

                    // Note title label
                    _buildLabelSkeleton(width: 90.w),

                    verticalSpace(8),

                    // Note title field
                    _buildSkeletonBox(
                      height: 56.h,
                      borderRadius: BorderRadius.circular(18.r),
                    ),

                    verticalSpace(18),

                    // Description label
                    _buildLabelSkeleton(width: 82.w),

                    verticalSpace(8),

                    // Description field
                    _buildSkeletonBox(
                      height: 76.h,
                      borderRadius: BorderRadius.circular(18.r),
                    ),

                    verticalSpace(20),

                    // Grade and publication status
                    _buildOptionsSkeleton(),

                    verticalSpace(20),

                    // PDF picker
                    _buildSkeletonBox(
                      height: 116.h,
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                  ],
                ),
              ),
            ),

            verticalSpace(16),

            // Add note button
            SafeArea(
              top: false,
              minimum: EdgeInsets.only(bottom: 4.h),
              child: _buildSkeletonBox(
                height: 56.h,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLabelSkeleton({required double width}) {
    return Align(
      alignment: Alignment.centerRight,
      child: _buildSkeletonBox(
        width: width,
        height: 14.h,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }

  Widget _buildOptionsSkeleton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300.w) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSkeletonBox(
                height: 56.h,
                borderRadius: BorderRadius.circular(18.r),
              ),

              verticalSpace(12),

              _buildSkeletonBox(
                height: 56.h,
                borderRadius: BorderRadius.circular(18.r),
              ),
            ],
          );
        }

        return Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              flex: 3,
              child: _buildSkeletonBox(
                height: 56.h,
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),

            horizontalSpace(16),

            Expanded(
              flex: 5,
              child: _buildSkeletonBox(
                height: 56.h,
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
          ],
        );
      },
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
