import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';

class LiveSessionBackground extends StatelessWidget {
  const LiveSessionBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final topColor = Color.lerp(
          ColorPalette.border,
          ColorPalette.textMuted,
          0.35,
        )!;

        final middleColor = Color.lerp(
          ColorPalette.paleSage,
          ColorPalette.background,
          0.65,
        )!;

        final bottomColor = Color.lerp(
          ColorPalette.background,
          ColorPalette.highlight,
          0.10,
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
                    middleColor,
                    ColorPalette.background,
                    bottomColor,
                  ],
                  stops: const [0, 0.36, 0.67, 1],
                ),
              ),
            ),

            Positioned(
              top: -height * 0.13,
              left: -width * 0.35,
              width: width * 1.10,
              height: height * 0.48,
              child: const _BackgroundGlow(
                color: ColorPalette.surface,
                opacity: 0.58,
              ),
            ),

            Positioned(
              top: -height * 0.12,
              right: -width * 0.35,
              width: width * 1.10,
              height: height * 0.46,
              child: const _BackgroundGlow(
                color: ColorPalette.textMuted,
                opacity: 0.52,
              ),
            ),

            Positioned(
              left: -width * 0.50,
              top: height * 0.34,
              width: width * 1.15,
              height: height * 0.42,
              child: const _BackgroundGlow(
                color: ColorPalette.secondary,
                opacity: 0.10,
              ),
            ),

            Positioned(
              left: -width * 0.45,
              bottom: -height * 0.11,
              width: width * 1.20,
              height: height * 0.45,
              child: const _BackgroundGlow(
                color: ColorPalette.highlight,
                opacity: 0.30,
              ),
            ),

            Positioned(
              right: -width * 0.30,
              bottom: -height * 0.09,
              width: width,
              height: height * 0.42,
              child: const _BackgroundGlow(
                color: ColorPalette.accent,
                opacity: 0.23,
              ),
            ),

            Positioned.fill(
              child: IgnorePointer(
                child: _LiveSessionDecorations(width: width, height: height),
              ),
            ),

            child,
          ],
        );
      },
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow({required this.color, required this.opacity});

  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _LiveSessionDecorations extends StatelessWidget {
  const _LiveSessionDecorations({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: width * 0.035,
          bottom: height * 0.18,
          child: Icon(
            Icons.hub_outlined,
            size: width * 0.18,
            color: ColorPalette.primary.withValues(alpha: 0.22),
          ),
        ),

        Positioned(
          right: width * 0.10,
          bottom: height * 0.205,
          child: Icon(
            Icons.science_outlined,
            size: width * 0.055,
            color: ColorPalette.primaryHover.withValues(alpha: 0.38),
          ),
        ),

        Positioned(
          left: width * 0.095,
          bottom: height * 0.145,
          child: Icon(
            Icons.colorize_outlined,
            size: width * 0.05,
            color: ColorPalette.highlight.withValues(alpha: 0.55),
          ),
        ),

        Positioned(
          left: width * 0.385,
          bottom: height * 0.18,
          child: Icon(
            Icons.colorize_outlined,
            size: width * 0.042,
            color: ColorPalette.accent.withValues(alpha: 0.30),
          ),
        ),

        Positioned(
          right: width * 0.16,
          bottom: height * 0.115,
          child: Transform.rotate(
            angle: 1.57,
            child: Icon(
              Icons.vaccines_outlined,
              size: width * 0.05,
              color: ColorPalette.secondary.withValues(alpha: 0.30),
            ),
          ),
        ),
      ],
    );
  }
}
