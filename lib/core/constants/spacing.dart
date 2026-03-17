import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Base unit
  static const double unit = 4.0;

  // Spacing scale
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;

  // Screen padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets screenPaddingAll = EdgeInsets.all(16.0);

  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPaddingSmall = EdgeInsets.all(12.0);

  // Section spacing
  static const double sectionGap = 24.0;
  static const double itemGap = 12.0;

  // Border radius
  static const double radiusSm = 6.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusRound = 100.0;

  // Card
  static BorderRadius cardRadius = BorderRadius.circular(radiusMd);
  static BorderRadius chipRadius = BorderRadius.circular(radiusRound);
  static BorderRadius buttonRadius = BorderRadius.circular(radiusMd);
}
