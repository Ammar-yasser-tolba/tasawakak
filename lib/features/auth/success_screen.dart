import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/brand/brand_palette.dart';
import '../../core/routes/route_names.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key, this.fromCreateAccount = false});

  final bool fromCreateAccount;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _autoCloseTimer = Timer(const Duration(seconds: 2), _goToLogin);
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fromCreateAccount = widget.fromCreateAccount;
    final title = fromCreateAccount
        ? 'create account successful'
        : 'Wait until complete';
    final checkColor = fromCreateAccount
        ? BrandPalette.success
        : BrandPalette.navy;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.92 + 0.08 * value,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, BrandPalette.goldMist],
                  ),
                  border: Border.all(color: BrandPalette.goldSoft, width: 1.4),
                  boxShadow: [
                    BoxShadow(
                      color: BrandPalette.gold.withValues(alpha: 0.24),
                      blurRadius: 26,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 46,
                  color: checkColor,
                ),
              ),
              const SizedBox(height: 26),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: BrandPalette.navy,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 38,
                height: 2,
                color: BrandPalette.goldSoft,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
