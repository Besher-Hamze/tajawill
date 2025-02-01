import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Rich Indigo
  static const primary = Color(0xFF4F46E5);  // Vibrant indigo
  static const primaryLight = Color(0xFF818CF8);  // Light indigo
  static const primaryDark = Color(0xFF3730A3);  // Dark indigo

  // Secondary Colors - Ocean Blue
  static const secondary = Color(0xFF0EA5E9);  // Bright blue
  static const secondaryLight = Color(0xFF38BDF8);  // Light blue
  static const secondaryDark = Color(0xFF0369A1);  // Dark blue

  // Accent Colors
  static const accent = Color(0xFFF43F5E);  // Vibrant rose
  static const accentLight = Color(0xFFFF8CA4);  // Light rose
  static const accentDark = Color(0xFFBE123C);  // Dark rose

  // Background Colors
  static const background = Color(0xFFF8FAFC);  // Light gray blue
  static const backgroundAlt = Color(0xFFEFF6FF);  // Light blue tint
  static const card = Color(0xFFFFFFFF);  // Pure white
  static const cardAlt = Color(0xFFF1F5F9);  // Light gray

  // Text Colors
  static const text = Color(0xFF0F172A);  // Dark blue gray
  static const textLight = Color(0xFF64748B);  // Medium gray
  static const textLighter = Color(0xFF94A3B8);  // Light gray

  // Status Colors
  static const success = Color(0xFF10B981);  // Emerald green
  static const warning = Color(0xFFF59E0B);  // Amber
  static const error = Color(0xFFEF4444);  // Red
  static const info = Color(0xFF6366F1);  // Indigo

  // Gradient Colors
  static const gradientStart = Color(0xFF4F46E5);  // Primary color
  static const gradientMiddle = Color(0xFF0EA5E9);  // Secondary color
  static const gradientEnd = Color(0xFF10B981);  // Success color

  // Overlay Colors
  static const overlay = Color(0x80000000);  // Semi-transparent black
  static const overlayLight = Color(0x40000000);  // Light overlay

  // Social Colors
  static const facebook = Color(0xFF1877F2);
  static const google = Color(0xFFDB4437);
  static const twitter = Color(0xFF1DA1F2);

  // Gradient List for easy use
  static const List<Color> primaryGradient = [
    gradientStart,
    gradientMiddle,
    gradientEnd,
  ];

  // Box Shadows
  static List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: text.withOpacity(0.04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> largeShadow = [
    BoxShadow(
      color: text.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}