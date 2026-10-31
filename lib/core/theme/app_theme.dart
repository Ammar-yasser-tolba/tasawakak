import 'package:flutter/material.dart';

import '../brand/brand_palette.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: BrandPalette.navy,
      onPrimary: Colors.white,
      primaryContainer: BrandPalette.navySoft,
      onPrimaryContainer: Colors.white,
      secondary: BrandPalette.gold,
      onSecondary: BrandPalette.navyDeep,
      secondaryContainer: BrandPalette.goldMist,
      onSecondaryContainer: BrandPalette.navy,
      surface: Colors.white,
      onSurface: BrandPalette.navy,
      error: BrandPalette.error,
      onError: Colors.white,
      outline: BrandPalette.border,
      outlineVariant: BrandPalette.goldSoft,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Cairo',
      scaffoldBackgroundColor: BrandPalette.canvas,
      visualDensity: VisualDensity.standard,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: 'Cairo',
        bodyColor: BrandPalette.navy,
        displayColor: BrandPalette.navy,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        hintStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13.5,
          fontWeight: FontWeight.w400,
          color: BrandPalette.hint,
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: BrandPalette.error,
          height: 1.5,
          letterSpacing: 0.1,
        ),
        errorMaxLines: 3,
        border: _border(BrandPalette.border),
        enabledBorder: _border(BrandPalette.border),
        focusedBorder: _border(BrandPalette.gold, width: 1.6),
        errorBorder: _border(BrandPalette.error),
        focusedErrorBorder: _border(BrandPalette.error, width: 1.6),
        disabledBorder: _border(BrandPalette.border),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: BrandPalette.goldDeep,
        selectionColor: BrandPalette.gold.withValues(alpha: 0.28),
        selectionHandleColor: BrandPalette.goldDeep,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: BrandPalette.navy,
        contentTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: Colors.white,
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dividerTheme: const DividerThemeData(
        color: BrandPalette.border,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: BrandPalette.navy,
      ),
      splashColor: BrandPalette.gold.withValues(alpha: 0.12),
      highlightColor: BrandPalette.navy.withValues(alpha: 0.04),
      splashFactory: InkSparkle.splashFactory,
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
