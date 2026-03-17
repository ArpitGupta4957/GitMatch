import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _baseFont => GoogleFonts.inter();

  // Headings
  static TextStyle heading1 = _baseFont.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    height: 1.2,
  );

  static TextStyle heading2 = _baseFont.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    height: 1.3,
  );

  static TextStyle heading3 = _baseFont.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    height: 1.3,
  );

  static TextStyle heading4 = _baseFont.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    height: 1.4,
  );

  // Body
  static TextStyle bodyLarge = _baseFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = _baseFont.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall = _baseFont.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Labels
  static TextStyle labelLarge = _baseFont.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 0.5,
  );

  static TextStyle labelMedium = _baseFont.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.8,
  );

  static TextStyle labelSmall = _baseFont.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 1.0,
  );

  // Button
  static TextStyle button = _baseFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  static TextStyle buttonSmall = _baseFont.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  // Chips/Badges
  static TextStyle chip = _baseFont.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle badge = _baseFont.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: 1.2,
  );

  // Caption
  static TextStyle caption = _baseFont.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // Stats
  static TextStyle statNumber = _baseFont.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );

  static TextStyle statLabel = _baseFont.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 1.0,
  );

  // Subtitle
  static TextStyle subtitle = _baseFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );
}
