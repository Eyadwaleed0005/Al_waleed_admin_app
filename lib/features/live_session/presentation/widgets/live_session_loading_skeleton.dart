import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/features/live_session/presentation/widgets/live_session_welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionLoadingSkeleton extends StatefulWidget {
  const LiveSessionLoadingSkeleton({super.key});

  @override
  State<LiveSessionLoadingSkeleton> createState() {
    return _LiveSessionLoadingSkeletonState();
  }
}

class _LiveSessionLoadingSkeletonState
    extends State<LiveSessionLoadingSkeleton>
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
      child: const LiveSessionWelcome(),
      builder: (context, welcomeWidget) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              welcomeWidget!,

              verticalSpace(24),

              Align(
                alignment: Alignment.centerRight,
                child: _buildSkeletonBox(
                  width: 72.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),

              verticalSpace(10),

              _buildSkeletonBox(
                height: 56.h,
                borderRadius: BorderRadius.circular(16.r),
              ),

              verticalSpace(24),

              Align(
                alignment: Alignment.centerRight,
                child: _buildSkeletonBox(
                  width: 84.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),

              verticalSpace(10),

              Row(
                children: [
                  Expanded(
                    child: _buildSkeletonBox(
                      height: 76.h,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),

                  horizontalSpace(12),

                  Expanded(
                    child: _buildSkeletonBox(
                      height: 76.h,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ],
              ),

              verticalSpace(24),

              Align(
                alignment: Alignment.centerRight,
                child: _buildSkeletonBox(
                  width: 78.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),

              verticalSpace(10),

              _buildSkeletonBox(
                height: 56.h,
                borderRadius: BorderRadius.circular(16.r),
              ),

              verticalSpace(24),

              _buildSkeletonBox(
                height: 56.h,
                borderRadius: BorderRadius.circular(16.r),
              ),

              verticalSpace(24),
            ],
          ),
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