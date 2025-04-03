import 'package:flutter/material.dart';

/// A reusable date/time selector widget.
///
/// This widget displays a card that allows selecting a date and/or time.
class DateTimeSelector extends StatelessWidget {
  /// The title to display when a value is selected.
  final String selectedTitle;
  
  /// The title to display when no value is selected.
  final String unselectedTitle;
  
  /// The subtitle to display when a value is selected.
  final String? selectedSubtitle;
  
  /// The subtitle to display when no value is selected.
  final String unselectedSubtitle;
  
  /// The icon to display.
  final IconData icon;
  
  /// The tooltip to display when hovering over the selector.
  final String tooltip;
  
  /// Callback for when the selector is tapped.
  final VoidCallback onTap;
  
  /// Whether a value is selected.
  final bool hasValue;
  
  /// The color to use for the selected state.
  final Color? accentColor;
  
  /// Creates a date/time selector.
  ///
  /// The [selectedTitle] parameter is the title to display when a value is selected.
  /// The [unselectedTitle] parameter is the title to display when no value is selected.
  /// The [selectedSubtitle] parameter is the subtitle to display when a value is selected.
  /// The [unselectedSubtitle] parameter is the subtitle to display when no value is selected.
  /// The [icon] parameter is the icon to display.
  /// The [tooltip] parameter is the tooltip to display when hovering over the selector.
  /// The [onTap] parameter is called when the selector is tapped.
  /// The [hasValue] parameter indicates whether a value is selected.
  /// The [accentColor] parameter is optional and defaults to the primary color.
  const DateTimeSelector({
    super.key,
    required this.selectedTitle,
    required this.unselectedTitle,
    this.selectedSubtitle,
    required this.unselectedSubtitle,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.hasValue,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;
    
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Tooltip(
          message: tooltip,
          child: InkWell(
            onTap: onTap,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    hasValue
                        ? color.withValues(alpha: 0.05)
                        : theme.colorScheme.surfaceContainerLowest,
                    hasValue
                        ? color.withValues(alpha: 0.1)
                        : theme.colorScheme.surfaceContainerLowest,
                  ],
                ),
                border: Border.all(
                  color: hasValue
                      ? color.withValues(alpha: 0.3)
                      : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: hasValue
                            ? color.withValues(alpha: 0.1)
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          icon,
                          color: hasValue
                              ? color
                              : theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasValue ? selectedTitle : unselectedTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: hasValue
                                  ? color
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hasValue ? (selectedSubtitle ?? '') : unselectedSubtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: hasValue
                                  ? color.withValues(alpha: 0.8)
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: hasValue
                          ? color
                          : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
