import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography System - PRD Section 08
/// Headings: Fraunces / Playfair Display (premium editorial)
/// Body Latin: Inter
/// Body Hindi: Noto Sans Devanagari
/// Spec: JetBrains Mono
class AppTypography {
  // Headings - Fraunces (rounded serif, premium)
  static TextStyle headingDisplay = GoogleFonts.fraunces(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static TextStyle heading1 = GoogleFonts.fraunces(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static TextStyle heading2 = GoogleFonts.fraunces(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static TextStyle heading3 = GoogleFonts.fraunces(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // Alternative heading - Playfair Display
  static TextStyle headingPlayfair = GoogleFonts.playfairDisplay(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
  );

  // Body - Inter
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Body Hindi - Noto Sans Devanagari
  static TextStyle bodyHindi = GoogleFonts.notoSansDevanagari(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // UI Labels
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Button
  static TextStyle button = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  // Caption / Spec - JetBrains Mono
  static TextStyle captionMono = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );
}
