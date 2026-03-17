import 'package:flutter/material.dart';

class AppAnimations {
  AppAnimations._();

  // Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration swipe = Duration(milliseconds: 300);

  // Curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve swipeCurve = Curves.easeOut;

  // Fade transition
  static Widget fadeIn({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(opacity: animation, child: child);
  }

  // Slide from bottom
  static Widget slideUp({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: defaultCurve)),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  // Slide from right
  static Widget slideRight({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: defaultCurve)),
      child: child,
    );
  }

  // Scale transition
  static Widget scaleIn({
    required Widget child,
    required Animation<double> animation,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: defaultCurve),
      ),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  // Page route with slide
  static Route<T> slidePageRoute<T>({required Widget page}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: defaultCurve)),
          child: child,
        );
      },
      transitionDuration: medium,
    );
  }

  // Page route with fade
  static Route<T> fadePageRoute<T>({required Widget page}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: medium,
    );
  }
}

// Staggered animation helper
class StaggeredAnimation {
  final int index;
  final int totalItems;
  final Duration totalDuration;

  StaggeredAnimation({
    required this.index,
    required this.totalItems,
    this.totalDuration = const Duration(milliseconds: 800),
  });

  Duration get delay =>
      Duration(milliseconds: (index * totalDuration.inMilliseconds ~/ totalItems));
}
