import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary backgrounds
  static const Color primary = Color(0xFF0D1117);
  static const Color secondary = Color(0xFF161B22);
  static const Color surface = Color(0xFF1C2128);
  static const Color cardBackground = Color(0xFF161B22);
  static const Color cardBorder = Color(0xFF30363D);

  // Accent
  static const Color accent = Color(0xFF238636);
  static const Color accentLight = Color(0xFF2EA043);
  static const Color accentDark = Color(0xFF1A7F37);

  // Text
  static const Color textPrimary = Color(0xFFC9D1D9);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status
  static const Color error = Color(0xFFF85149);
  static const Color warning = Color(0xFFD29922);
  static const Color info = Color(0xFF58A6FF);
  static const Color success = Color(0xFF3FB950);

  // Swipe
  static const Color swipeReject = Color(0xFFF85149);
  static const Color swipeSave = Color(0xFF238636);

  // Badges
  static const Color badgeLive = Color(0xFFF85149);
  static const Color badgeTrending = Color(0xFF238636);
  static const Color badgeNew = Color(0xFF238636);
  static const Color badgeOffering = Color(0xFF238636);
  static const Color badgeSeeking = Color(0xFF58A6FF);

  // Bottom nav
  static const Color navActive = Color(0xFF238636);
  static const Color navInactive = Color(0xFF8B949E);

  // Shimmer
  static const Color shimmerBase = Color(0xFF161B22);
  static const Color shimmerHighlight = Color(0xFF30363D);

  // Chart / stats
  static const Color chartGreen = Color(0xFF238636);
  static const Color chartBlue = Color(0xFF58A6FF);
  static const Color chartOrange = Color(0xFFD29922);
  static const Color chartPurple = Color(0xFFBC8CFF);
  static const Color chartRed = Color(0xFFF85149);

  // Gradient
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF238636), Color(0xFF2EA043)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF161B22), Color(0xFF0D1117)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
