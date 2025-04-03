import 'package:flutter/material.dart';

/// Button types for the StyledButton widget.
enum StyledButtonType {
  /// Primary button with the primary color.
  primary,

  /// Secondary button with the secondary color.
  secondary,

  /// Danger button with the error color.
  danger,

  /// Outline button with a transparent background and colored border.
  outline,
}

/// A styled button with a modern design.
///
/// This button features a gradient background, subtle shadow, and rounded corners.
/// It can be configured with different types (primary, secondary, danger, outline).
class StyledButton extends StatelessWidget {
  /// The label text to display on the button.
  final String label;

  /// The icon to display on the button.
  final IconData? icon;

  /// The callback to execute when the button is pressed.
  final VoidCallback? onPressed;

  /// The type of button to display.
  final StyledButtonType type;

  /// The width of the button. If null, the button will size itself to fit its content.
  final double? width;

  /// The height of the button.
  final double height;

  /// The border radius for the button corners.
  final double borderRadius;

  /// Whether to add a shadow to the button.
  final bool withShadow;

  /// Creates a styled button.
  ///
  /// The [label] parameter is required and displayed as the button text.
  /// The [onPressed] parameter is required and executed when the button is pressed.
  /// The [icon], [type], [width], [height], [borderRadius], and [withShadow] parameters
  /// allow customizing the button appearance.
  const StyledButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.type = StyledButtonType.primary,
    this.width,
    this.height = 56.0,
    this.borderRadius = 16.0,
    this.withShadow = true,
  });

  // Cache button styles for better performance
  ButtonStyle _getButtonStyle(
    BuildContext context,
    Color backgroundColor,
    Color foregroundColor,
  ) {
    final theme = Theme.of(context);

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side:
            type == StyledButtonType.outline
                ? BorderSide(color: theme.colorScheme.primary)
                : BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      minimumSize: Size(width ?? 0, height),
    );
  }

  // Get colors based on button type
  Map<String, Color> _getButtonColors(ThemeData theme) {
    switch (type) {
      case StyledButtonType.primary:
        return {
          'background': theme.colorScheme.primary,
          'foreground': theme.colorScheme.onPrimary,
          'shadow': theme.colorScheme.primary,
        };
      case StyledButtonType.secondary:
        return {
          'background': theme.colorScheme.secondary,
          'foreground': theme.colorScheme.onSecondary,
          'shadow': theme.colorScheme.secondary,
        };
      case StyledButtonType.danger:
        return {
          'background': theme.colorScheme.error,
          'foreground': theme.colorScheme.onError,
          'shadow': theme.colorScheme.error,
        };
      case StyledButtonType.outline:
        return {
          'background': Colors.transparent,
          'foreground': theme.colorScheme.primary,
          'shadow': Colors.transparent,
        };
      // All cases are covered, but we need to return something to satisfy the compiler
      // This code should never be reached
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getButtonColors(theme);
    final buttonStyle = _getButtonStyle(
      context,
      colors['background']!,
      colors['foreground']!,
    );

    // Optimize by conditionally creating the shadow container only when needed
    if (!withShadow) {
      return ElevatedButton.icon(
        icon: icon != null ? Icon(icon) : Container(width: 0),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          overflow: TextOverflow.visible,
          softWrap: false,
        ),
        onPressed: onPressed,
        style: buttonStyle,
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: colors['shadow']!.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        icon: icon != null ? Icon(icon) : Container(width: 0),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          overflow: TextOverflow.visible,
          softWrap: false,
        ),
        onPressed: onPressed,
        style: buttonStyle,
      ),
    );
  }
}
