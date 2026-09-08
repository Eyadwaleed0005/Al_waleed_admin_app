import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewExamsLoadingSkeleton extends StatefulWidget {
  const ViewExamsLoadingSkeleton({super.key});

  @override
  State<ViewExamsLoadingSkeleton> createState() =>
      _ViewExamsLoadingSkeletonState();
}

class _ViewExamsLoadingSkeletonState extends State<ViewExamsLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 0.35, end: 0.75).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Column(
        children: [
          _SkeletonBox(height: 52.h, borderRadius: 14.r),
          verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: _SkeletonBox(height: 50.h, borderRadius: 14.r),
              ),
              horizontalSpace(16),
              Expanded(
                child: _SkeletonBox(height: 50.h, borderRadius: 14.r),
              ),
            ],
          ),
          verticalSpace(24),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => verticalSpace(14),
              itemBuilder: (_, __) {
                return _ExamCardSkeleton();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}

class _ExamCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _SkeletonBox(height: 20.h, borderRadius: 8.r),
              ),
              horizontalSpace(26),
              _SkeletonBox(width: 75.w, height: 30.h, borderRadius: 20.r),
            ],
          ),
          verticalSpace(20),
          Align(
            alignment: Alignment.centerRight,
            child: _SkeletonBox(width: 220.w, height: 14.h, borderRadius: 7.r),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    this.width,
    required this.height,
    required this.borderRadius,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ColorPalette.border,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
