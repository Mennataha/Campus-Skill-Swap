import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF006156);
  static const Color primaryDark = Color(0xFF00504A);
  static const Color primaryLight = Color(0xFFA6F2E6);

  // Background Colors
  static const Color background = Color(0xFFF7F9FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFE9EFFF);
  static const Color surfaceBlue = Color(
    0xFFE1EAFF,
  ); // جديد: Chips وأيقونات بخلفية زرقاء فاتحة
  static const Color surfaceMint = Color(
    0xFFD6F5EF,
  ); // جديد: تدرج خلفية كارت البروفايل

  // Accent Colors
  static const Color accent = Color(0xFFF5B64C);
  static const Color accentLight = Color(0xFFFFDDB8);
  static const Color accentDark = Color(0xFF8A5100); // جديد: نص النقاط والتقييم
  static const Color star = Color(0xFFE08A00); // جديد: نجوم التقييم

  // Text Colors
  static const Color textPrimary = Color(0xFF111C2D);
  static const Color textSecondary = Color(0xFF3E4946);
  static const Color textHint = Color(0xFF6F7976);

  // Status Colors
  static const Color success = Color(0xFF279B72);
  static const Color warning = Color(0xFFE9A23B);
  static const Color error = Color(0xFFD9534F);
  static const Color info = Color(0xFF3987C9);

  // Border & Divider
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFEDF1F5);
}
