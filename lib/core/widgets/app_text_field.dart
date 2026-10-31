import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../brand/brand_palette.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.errorText,
    this.obscureText = false,
    this.onToggleObscure,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onFocusLost,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.labelTrailing,
    this.letterSpacing = 0,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? errorText;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFocusLost;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final Widget? labelTrailing;
  final double letterSpacing;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final iconColor = hasError ? BrandPalette.error : BrandPalette.goldDeep;

    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) onFocusLost?.call();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: BrandPalette.navy,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              ?labelTrailing,
            ],
          ),
          const SizedBox(height: 8),
          Directionality(
            textDirection: TextDirection.ltr,
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              onChanged: onChanged,
              textInputAction: textInputAction,
              autofillHints: autofillHints,
              autocorrect: false,
              enableSuggestions: false,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: BrandPalette.navy,
                letterSpacing: letterSpacing,
              ),
              cursorColor: BrandPalette.goldDeep,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                hintText: hint,
                errorText: errorText,
                prefixIcon: Icon(icon, size: 20, color: iconColor),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 52, minHeight: 52),
                suffixIcon: onToggleObscure == null
                    ? null
                    : IconButton(
                        onPressed: onToggleObscure,
                        icon: Icon(
                          obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: BrandPalette.inkMuted,
                        ),
                        tooltip: obscureText
                            ? 'إظهار كلمة السر'
                            : 'إخفاء كلمة السر',
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
