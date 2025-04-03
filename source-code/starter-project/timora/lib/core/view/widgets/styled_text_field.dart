import 'package:flutter/material.dart';

/// A styled text field with a modern design.
///
/// This text field features custom styling for borders, labels, and icons
/// to match the app's modern design language.
class StyledTextField extends StatelessWidget {
  /// The controller for the text field.
  final TextEditingController? controller;

  /// The label text to display.
  final String label;

  /// The icon to display as a prefix.
  final IconData? prefixIcon;

  /// The hint text to display when the field is empty.
  final String? hint;

  /// The validation function for the field.
  final String? Function(String?)? validator;

  /// Whether the field allows multiple lines of text.
  final bool multiline;

  /// The maximum number of lines to display when multiline is true.
  final int? maxLines;

  /// The keyboard type for the field.
  final TextInputType? keyboardType;

  /// Optional accent color for the field.
  /// If provided, it will be used for the icon and focus border.
  final Color? accentColor;

  /// Whether the field is enabled.
  final bool enabled;

  /// Callback for when the field value changes.
  final Function(String)? onChanged;

  /// Creates a styled text field.
  ///
  /// The [label] parameter is required and displayed as the field label.
  /// The [controller] parameter is optional but recommended for controlling the field value.
  /// The [prefixIcon], [hint], [validator], [multiline], [maxLines], [keyboardType],
  /// [accentColor], [enabled], and [onChanged] parameters allow customizing the field behavior.
  const StyledTextField({
    super.key,
    this.controller,
    required this.label,
    this.prefixIcon,
    this.hint,
    this.validator,
    this.multiline = false,
    this.maxLines,
    this.keyboardType,
    this.accentColor,
    this.enabled = true,
    this.onChanged,
  });

  // Create a cached decoration to avoid rebuilding it on every build
  InputDecoration _createInputDecoration(
    BuildContext context,
    Color primaryColor,
  ) {
    final theme = Theme.of(context);
    // Use the theme extension if available, otherwise use default value
    final borderRadius = 12.0;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon:
          prefixIcon != null
              ? Icon(
                prefixIcon,
                color: primaryColor.withValues(alpha: 0.7),
                semanticLabel: 'Field icon for $label',
              )
              : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = accentColor ?? theme.colorScheme.primary;

    // Create the decoration once per build
    final decoration = _createInputDecoration(context, primaryColor);

    return TextFormField(
      controller: controller,
      decoration: decoration,
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
      cursorColor: primaryColor,
      maxLines: multiline ? (maxLines ?? 3) : 1,
      keyboardType:
          keyboardType ?? (multiline ? TextInputType.multiline : null),
      validator: validator,
      enabled: enabled,
      onChanged: onChanged,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      // TextFormField doesn't have semanticsLabel parameter
      // We can add semantics in a parent widget if needed
    );
  }
}
