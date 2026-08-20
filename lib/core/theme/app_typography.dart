import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Crimson Text for Headers
  static TextStyle get header => GoogleFonts.crimsonText(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      );

  // Inter for Body and UI Elements
  static TextStyle get bodyInter => GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodyInterMedium => GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get bodyInterSemiBold => GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleLarge => bodyInterSemiBold.copyWith(fontSize: 22);
  static TextStyle get titleMedium => bodyInterMedium.copyWith(fontSize: 16);
  static TextStyle get labelMedium => bodyInterMedium.copyWith(fontSize: 12);
  static TextStyle get labelSmall => bodyInterMedium.copyWith(fontSize: 11);
      
  // TextTheme mapped to Material Design, using brand colors
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: header.copyWith(fontSize: 57),
      displayMedium: header.copyWith(fontSize: 45),
      displaySmall: header.copyWith(fontSize: 36),
      headlineLarge: header.copyWith(fontSize: 32),
      headlineMedium: header.copyWith(fontSize: 28),
      headlineSmall: header.copyWith(fontSize: 24),
      titleLarge: bodyInterSemiBold.copyWith(fontSize: 22),
      titleMedium: bodyInterMedium.copyWith(fontSize: 16),
      titleSmall: bodyInterMedium.copyWith(fontSize: 14),
      bodyLarge: bodyInter.copyWith(fontSize: 16),
      bodyMedium: bodyInter.copyWith(fontSize: 14),
      bodySmall: bodyInter.copyWith(fontSize: 12),
      labelLarge: bodyInterMedium.copyWith(fontSize: 14),
      labelMedium: bodyInterMedium.copyWith(fontSize: 12),
      labelSmall: bodyInterMedium.copyWith(fontSize: 11),
    );
  }
}
