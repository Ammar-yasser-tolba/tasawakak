import 'package:flutter/material.dart';

import '../brand/brand_palette.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 94});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.11),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: BrandPalette.goldSoft, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: BrandPalette.navy.withValues(alpha: 0.08),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/logo_mark.png',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        semanticLabel: 'شعار تسوقك',
      ),
    );
  }
}

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'تسوقك',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: BrandPalette.navy,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _GoldRule(),
            const SizedBox(width: 9),
            Text(
              'TASAWAKAK',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 4.2,
                color: BrandPalette.goldDeep.withValues(alpha: 0.95),
              ),
            ),
            const SizedBox(width: 9),
            const _GoldRule(),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'CLOTHES & WATCHES',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 8.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.4,
            color: BrandPalette.hint,
          ),
        ),
      ],
    );
  }
}

class _GoldRule extends StatelessWidget {
  const _GoldRule();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 1,
      color: BrandPalette.goldSoft,
    );
  }
}
