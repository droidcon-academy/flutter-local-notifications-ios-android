import 'package:flutter/material.dart';

/// A styled badge with a modern design.
///
/// This badge features a colored background, subtle shadow, and rounded corners.
/// It can be used to display category labels, status indicators, or other small pieces of information.
class StyledBadge extends StatelessWidget {
  /// The text to display in the badge.
  final String text;
  
  /// The color of the badge.
  final Color color;
  
  /// The text style for the badge text.
  final TextStyle? textStyle;
  
  /// The padding to apply inside the badge.
  final EdgeInsetsGeometry padding;
  
  /// The border radius for the badge corners.
  final double borderRadius;
  
  /// Creates a styled badge.
  ///
  /// The [text] parameter is required and displayed as the badge text.
  /// The [color] parameter is required and used as the badge background color.
  /// The [textStyle], [padding], and [borderRadius] parameters allow customizing the badge appearance.
  const StyledBadge({
    super.key,
    required this.text,
    required this.color,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        text,
        style: textStyle ?? TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: color.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
