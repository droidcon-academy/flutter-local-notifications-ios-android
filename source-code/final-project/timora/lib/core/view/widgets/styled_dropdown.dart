import 'package:flutter/material.dart';

/// A styled dropdown field with a modern design.
///
/// This dropdown field features custom styling for borders, labels, and icons
/// to match the app's modern design language.
class StyledDropdown<T> extends StatelessWidget {
  /// The label text to display.
  final String label;

  /// The icon to display as a prefix.
  final IconData? prefixIcon;

  /// The currently selected value.
  final T? value;

  /// The list of items to display in the dropdown.
  final List<DropdownMenuItem<T>> items;

  /// Callback for when the selected value changes.
  final Function(T?)? onChanged;

  /// Optional accent color for the field.
  /// If provided, it will be used for the icon and focus border.
  final Color? accentColor;

  /// Whether the field is enabled.
  final bool enabled;

  /// Creates a styled dropdown field.
  ///
  /// The [label] parameter is required and displayed as the field label.
  /// The [value] parameter is required and represents the currently selected value.
  /// The [items] parameter is required and contains the list of items to display.
  /// The [onChanged] parameter is called when the selected value changes.
  /// The [prefixIcon], [accentColor], and [enabled] parameters allow customizing the field behavior.
  const StyledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
    this.accentColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = accentColor ?? theme.colorScheme.primary;
    final borderRadius = 12.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.5,
        ),
        color: theme.colorScheme.surfaceContainerLowest,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (prefixIcon != null)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(prefixIcon, color: primaryColor, size: 20),
              ),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: prefixIcon != null ? 12 : 16,
                right: 16,
              ),
              child: DropdownButtonFormField<T>(
                value: value,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                ),
                dropdownColor: theme.colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(borderRadius),
                icon: SizedBox(),
                items: items,
                onChanged: enabled ? onChanged : null,
                isExpanded: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
