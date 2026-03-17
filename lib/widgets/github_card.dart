import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/spacing.dart';

class GitHubCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool hasBorder;
  final BorderRadius? borderRadius;

  const GitHubCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.hasBorder = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      child: Material(
        color: backgroundColor ?? AppColors.cardBackground,
        borderRadius: borderRadius ?? AppSpacing.cardRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? AppSpacing.cardRadius,
          child: Container(
            padding: padding ?? AppSpacing.cardPadding,
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? AppSpacing.cardRadius,
              border: hasBorder
                  ? Border.all(color: AppColors.cardBorder, width: 1)
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Full-width card with image header
class GitHubImageCard extends StatelessWidget {
  final Widget imageWidget;
  final Widget child;
  final VoidCallback? onTap;
  final double imageHeight;

  const GitHubImageCard({
    super.key,
    required this.imageWidget,
    required this.child,
    this.onTap,
    this.imageHeight = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: imageWidget,
            ),
            Padding(
              padding: AppSpacing.cardPadding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
