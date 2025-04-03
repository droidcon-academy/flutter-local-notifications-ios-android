import 'package:flutter/material.dart';

/// A reusable chip selector widget.
///
/// This widget displays a list of options as choice chips and handles selection.
class ChipSelector extends StatelessWidget {
  /// The list of options to display.
  final List<String> options;

  /// The currently selected option.
  final String? selectedOption;

  /// Callback for when an option is selected.
  final Function(String) onSelected;

  /// The color to use for the selected chip.
  final Color? selectedColor;

  /// Optional function to customize the display label for each option.
  final String Function(String)? customLabelBuilder;

  /// Creates a chip selector.
  ///
  /// The [options] parameter is required and contains the list of options to display.
  /// The [selectedOption] parameter is the currently selected option.
  /// The [onSelected] parameter is called when an option is selected.
  /// The [selectedColor] parameter is optional and defaults to the primary color.
  /// The [customLabelBuilder] parameter is optional and allows customizing the display label for each option.
  const ChipSelector({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
    this.selectedColor,
    this.customLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selectedColor ?? theme.colorScheme.primary;

    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children:
          options.map((option) {
            final isSelected = selectedOption == option;

            final displayLabel =
                customLabelBuilder != null
                    ? customLabelBuilder!(option)
                    : option;

            return ChoiceChip(
              checkmarkColor: theme.colorScheme.onPrimary,
              label: Text(displayLabel),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelected(option);
                }
              },
              selectedColor: color,
              backgroundColor: theme.colorScheme.surfaceContainerLowest,
              labelStyle: TextStyle(
                color:
                    isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              elevation: 0,
              pressElevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color:
                      isSelected
                          ? Colors.transparent
                          : theme.colorScheme.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
                  width: 1.5,
                ),
              ),
              shadowColor: color.withValues(alpha: 0.3),
            );
          }).toList(),
    );
  }
}
