import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateStudentLoadingSkeleton extends StatefulWidget {
  const UpdateStudentLoadingSkeleton({super.key});

  @override
  State<UpdateStudentLoadingSkeleton> createState() {
    return _UpdateStudentLoadingSkeletonState();
  }
}

class _UpdateStudentLoadingSkeletonState
    extends State<UpdateStudentLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.45, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: AbsorbPointer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SkeletonFormField(labelWidth: 82),
                verticalSpace(18),
                const Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _SkeletonFormField(labelWidth: 66)),
                    _HorizontalSkeletonSpacing(),
                    Expanded(child: _SkeletonFormField(labelWidth: 72)),
                  ],
                ),
                verticalSpace(18),
                const _SkeletonFormField(labelWidth: 75),
                verticalSpace(18),
                const _SkeletonFormField(labelWidth: 110),
                verticalSpace(18),
                const _SkeletonFormField(labelWidth: 145),
                verticalSpace(18),
                const Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _SkeletonFormField(labelWidth: 92)),
                    _HorizontalSkeletonSpacing(),
                    Expanded(child: _SkeletonFormField(labelWidth: 92)),
                  ],
                ),
                verticalSpace(28),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const Expanded(child: _SkeletonButton()),
                    horizontalSpace(12),
                    const Expanded(child: _SkeletonButton()),
                  ],
                ),
                verticalSpace(14),
                const _SkeletonButton(),
                verticalSpace(14),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const Expanded(child: _SkeletonButton()),
                    horizontalSpace(12),
                    const _SkeletonCircleButton(),
                  ],
                ),
                verticalSpace(16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }
}

class _SkeletonFormField extends StatelessWidget {
  const _SkeletonFormField({required this.labelWidth});

  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: _SkeletonBox(
            width: labelWidth.w,
            height: 11.h,
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        verticalSpace(8),
        _SkeletonBox(height: 54.h, borderRadius: BorderRadius.circular(15.r)),
      ],
    );
  }
}

class _SkeletonButton extends StatelessWidget {
  const _SkeletonButton();

  @override
  Widget build(BuildContext context) {
    return _SkeletonBox(
      height: 54.h,
      borderRadius: BorderRadius.circular(15.r),
    );
  }
}

class _SkeletonCircleButton extends StatelessWidget {
  const _SkeletonCircleButton();

  @override
  Widget build(BuildContext context) {
    return _SkeletonBox(
      width: 54.w,
      height: 54.w,
      borderRadius: BorderRadius.circular(100.r),
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
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ColorPalette.primary.withValues(alpha: 0.12),
        borderRadius: borderRadius,
        border: Border.all(color: ColorPalette.primary.withValues(alpha: 0.05)),
      ),
    );
  }
}

class _HorizontalSkeletonSpacing extends StatelessWidget {
  const _HorizontalSkeletonSpacing();

  @override
  Widget build(BuildContext context) {
    return horizontalSpace(12);
  }
}
