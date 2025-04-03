import 'package:flutter/material.dart';

/// A modern card widget with a sleek design.
///
/// This card features a gradient background, subtle shadow, and rounded corners.
/// It can include an optional header with an icon and title.
class ModernCard extends StatelessWidget {
  /// The title to display in the card header.
  final String? title;
  
  /// The icon to display in the card header.
  final IconData? icon;
  
  /// The child widget to display in the card body.
  final Widget child;
  
  /// The padding to apply to the card content.
  final EdgeInsetsGeometry contentPadding;
  
  /// The margin to apply around the card.
  final EdgeInsetsGeometry margin;
  
  /// The border radius for the card corners.
  final double borderRadius;
  
  /// The shadow elevation for the card.
  final double elevation;
  
  /// Optional accent color for the card.
  /// If provided, it will be used for the icon background and border.
  final Color? accentColor;
  
  /// Creates a modern card widget.
  ///
  /// The [child] parameter is required and represents the main content of the card.
  /// The [title] and [icon] parameters are optional and used for the card header.
  /// The [contentPadding], [margin], [borderRadius], and [elevation] parameters
  /// allow customizing the card appearance.
  const ModernCard({
    super.key,
    this.title,
    this.icon,
    required this.child,
    this.contentPadding = const EdgeInsets.all(20.0),
    this.margin = const EdgeInsets.only(bottom: 24.0),
    this.borderRadius = 16.0,
    this.elevation = 1.0,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = accentColor ?? theme.colorScheme.primary;
    
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withValues(alpha: 0.95),
                ],
              ),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Padding(
              padding: contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null || icon != null) ...[
                    _buildHeader(context, primaryColor),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the card header with an icon and title.
  Widget _buildHeader(BuildContext context, Color primaryColor) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
        ],
        if (title != null)
          Expanded(
            child: Text(
              title!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.3,
              ),
            ),
          ),
      ],
    );
  }
}
