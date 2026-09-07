import 'package:flutter/material.dart';

/// Design System Palette - PRD Section 08 (Page 7)
/// Premium • Reliable • Indian-First
class AppColors {
  // Primary Palette
  static const twilightPlum = Color(0xFF3B2452); // PRIMARY - Premium formal+festive
  static const marigoldGold = Color(0xFFE8A33D); // ACCENT - Bridges Indian decor + Western
  static const blushCoral = Color(0xFFF2726F); // SECONDARY ACCENT - Love/celebration
  static const warmIvory = Color(0xFFFBF8F3); // BACKGROUND - Neutral warmth
  static const charcoalInk = Color(0xFF241F26); // TEXT - High contrast softer than black

  // Semantic Tokens
  static const success = Color(0xFF2E9E6D);
  static const warning = Color(0xFFE1A93B);
  static const error = Color(0xFFD64550);
  static const info = Color(0xFF3D7EBF);

  // Dark Mode - PRD Section 08
  static const darkBackground = Color(0xFF1C1620);
  static const darkSurface = Color(0xFF241D29);
  static const darkText = Color(0xFFF3EDF7);

  // Light surfaces
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF3EDF7);
  static const border = Color(0xFFE8E0EC);
  static const hint = Color(0xFF9A8DA3);

  // Watermark for free tier
  static const watermark = Color(0x1A3B2452);

  // Gradient helper for premium feel
  static const plumGradient = LinearGradient(
    colors: [Color(0xFF3B2452), Color(0xFF5B3A7A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const goldGradient = LinearGradient(
    colors: [Color(0xFFE8A33D), Color(0xFFF2726F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
