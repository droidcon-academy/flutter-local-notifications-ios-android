import 'package:flutter/material.dart';

/// A container with a gradient background.
///
/// This widget provides a consistent gradient background that can be used
/// across different screens in the app.
class GradientBackground extends StatelessWidget {
  /// The child widget to display on top of the gradient background.
  final Widget child;
  
  /// The start alignment for the gradient.
  final Alignment begin;
  
  /// The end alignment for the gradient.
  final Alignment end;
  
  /// Optional custom colors for the gradient.
  /// If not provided, the default surface colors from the theme will be used.
  final List<Color>? colors;
  
  /// Creates a gradient background container.
  ///
  /// The [child] parameter is required and displayed on top of the gradient.
  /// The [begin], [end], and [colors] parameters allow customizing the gradient.
  const GradientBackground({
    super.key,
    required this.child,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ?? [
            theme.colorScheme.surface.withValues(alpha: 0.95),
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: child,
    );
  }
}
