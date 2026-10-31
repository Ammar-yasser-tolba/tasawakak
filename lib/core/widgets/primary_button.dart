import 'package:flutter/material.dart';

import '../brand/brand_palette.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.subLabel,
    this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final String? subLabel;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;

    return AnimatedScale(
      scale: _pressed && enabled ? 0.975 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: enabled
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFDDC07E),
                    BrandPalette.gold,
                    Color(0xFFB8924A),
                  ],
                )
              : const LinearGradient(
                  colors: [Color(0xFFDCD7CB), Color(0xFFCFC9BC)],
                ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: BrandPalette.gold.withValues(alpha: 0.38),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: enabled ? widget.onPressed : null,
            onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
            onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
            onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
            splashColor: BrandPalette.navy.withValues(alpha: 0.08),
            highlightColor: BrandPalette.navy.withValues(alpha: 0.04),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: BrandPalette.navy,
                      ),
                    )
                  : Text.rich(
                      TextSpan(
                        text: widget.label,
                        children: [
                          if (widget.subLabel != null)
                            TextSpan(
                              text: '  ·  ${widget.subLabel}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color:
                                    BrandPalette.navy.withValues(alpha: 0.68),
                                letterSpacing: 0.4,
                              ),
                            ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: BrandPalette.navy,
                        letterSpacing: 0.2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
