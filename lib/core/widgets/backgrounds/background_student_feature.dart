import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';

class BackgroundStudentFeature extends StatelessWidget {
  const BackgroundStudentFeature({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final topColor = Color.lerp(
          ColorPalette.accent,
          ColorPalette.paleSage,
          0.28,
        )!;

        final upperMiddleColor = Color.lerp(
          ColorPalette.paleSage,
          ColorPalette.surface,
          0.55,
        )!;

        final middleColor = Color.lerp(
          ColorPalette.surface,
          ColorPalette.border,
          0.45,
        )!;

        final lowerMiddleColor = Color.lerp(
          ColorPalette.surface,
          ColorPalette.highlight,
          0.22,
        )!;

        return Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    topColor,
                    upperMiddleColor,
                    middleColor,
                    lowerMiddleColor,
                    ColorPalette.highlight,
                  ],
                  stops: const [0, 0.27, 0.52, 0.68, 1],
                ),
              ),
            ),

            Positioned(
              left: -width * 0.48,
              top: height * 0.26,
              width: width * 1.35,
              height: height * 0.42,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        ColorPalette.secondary.withValues(alpha: 0.11),
                        ColorPalette.secondary.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              right: -width * 0.35,
              top: -height * 0.08,
              width: width,
              height: height * 0.40,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        ColorPalette.primary.withValues(alpha: 0.09),
                        ColorPalette.primary.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              right: -width * 0.42,
              top: -width * 0.55,
              child: IgnorePointer(
                child: Icon(
                  Icons.radar_outlined,
                  size: width * 1.30,
                  color: ColorPalette.primary.withValues(alpha: 0.035),
                ),
              ),
            ),

            Positioned(
              right: -width * 0.38,
              bottom: -width * 0.40,
              child: IgnorePointer(
                child: Icon(
                  Icons.radar_outlined,
                  size: width * 1.20,
                  color: ColorPalette.warning.withValues(alpha: 0.045),
                ),
              ),
            ),

            Positioned.fill(
              child: IgnorePointer(
                child: _StudentScienceDecorations(width: width, height: height),
              ),
            ),

            child,
          ],
        );
      },
    );
  }
}

class _StudentScienceDecorations extends StatelessWidget {
  const _StudentScienceDecorations({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: width * 0.055,
          bottom: height * 0.205,
          child: Icon(
            Icons.hub_outlined,
            size: width * 0.17,
            color: ColorPalette.primary.withValues(alpha: 0.13),
          ),
        ),
        Positioned(
          right: width * 0.095,
          bottom: height * 0.205,
          child: Icon(
            Icons.science_outlined,
            size: width * 0.055,
            color: ColorPalette.primaryHover.withValues(alpha: 0.65),
          ),
        ),
        Positioned(
          left: width * 0.385,
          bottom: height * 0.205,
          child: Icon(
            Icons.colorize_outlined,
            size: width * 0.042,
            color: ColorPalette.accent.withValues(alpha: 0.50),
          ),
        ),
        Positioned(
          left: width * 0.075,
          bottom: height * 0.145,
          child: Icon(
            Icons.colorize_outlined,
            size: width * 0.047,
            color: ColorPalette.highlight.withValues(alpha: 0.75),
          ),
        ),
        Positioned(
          right: width * 0.16,
          bottom: height * 0.115,
          child: Transform.rotate(
            angle: 1.57,
            child: Icon(
              Icons.vaccines_outlined,
              size: width * 0.052,
              color: ColorPalette.secondary.withValues(alpha: 0.55),
            ),
          ),
        ),
      ],
    );
  }
}
