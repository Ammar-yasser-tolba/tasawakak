import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/brand/brand_palette.dart';
import '../../core/routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 2500);

  // Stage 1: 0.0s – 0.8s entrance, then a clean hold until 1.5s.
  static const double _iconEntranceEnd = 800 / 2500;

  // Stage 2: text reveals below the fixed icon from 1.5s to 2.5s.
  static const double _textRevealStart = 1500 / 2500;
  static const double _textAspectRatio = 971 / 544;

  late final AnimationController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration)
      ..addStatusListener(_onAnimationStatus)
      ..forward();
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_onAnimationStatus)
      ..dispose();
    super.dispose();
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) _goToLogin();
  }

  void _goToLogin() {
    if (_navigated || !mounted) return;
    final route = ModalRoute.of(context);
    if (route == null || !route.isCurrent) return;
    _navigated = true;
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  double _iconOpacity(double t) {
    if (t >= _iconEntranceEnd) return 1;
    return Curves.easeOutCubic.transform(t / _iconEntranceEnd);
  }

  double _iconScale(double t) {
    if (t >= _iconEntranceEnd) return 1;
    final progress = Curves.easeOutBack.transform(t / _iconEntranceEnd);
    return 0.88 + 0.12 * progress;
  }

  double _textProgress(double t) {
    if (t <= _textRevealStart) return 0;
    final progress = (t - _textRevealStart) / (1 - _textRevealStart);
    return Curves.easeOutCubic.transform(progress.clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFDFCF9), BrandPalette.canvas],
                ),
              ),
            ),
          ),
          const Positioned(
            top: -120,
            right: -100,
            child: _SplashGlow(color: BrandPalette.gold, size: 330),
          ),
          const Positioned(
            bottom: -150,
            left: -120,
            child: _SplashGlow(color: BrandPalette.navy, size: 380),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final iconSize = math.min(constraints.maxWidth * 0.38, 158.0);
                final textWidth = iconSize * 1.45;
                final textHeight = textWidth / _textAspectRatio;
                final textGap = iconSize * 0.12;
                final centerY = constraints.maxHeight / 2;

                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final t = _controller.value;
                    final text = _textProgress(t);
                    return Stack(
                      children: [
                        Positioned(
                          top: centerY - iconSize / 2,
                          left: (constraints.maxWidth - iconSize) / 2,
                          width: iconSize,
                          height: iconSize,
                          child: Opacity(
                            key: const Key('splash-icon'),
                            opacity: _iconOpacity(t),
                            child: Transform.scale(
                              scale: _iconScale(t),
                              child: Image.asset(
                                'assets/splash/extracted_icon.png',
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                semanticLabel: 'شعار تسوقك',
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: centerY + iconSize / 2 + textGap,
                          left: (constraints.maxWidth - textWidth) / 2,
                          width: textWidth,
                          child: Opacity(
                            key: const Key('splash-text'),
                            opacity: text,
                            child: Transform.translate(
                              offset: Offset(0, (1 - text) * 18),
                              child: Image.asset(
                                'assets/splash/extracted_text.png',
                                height: textHeight,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                semanticLabel: 'تسوقك - ملابس وساعات',
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashGlow extends StatelessWidget {
  const _SplashGlow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.13),
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}
