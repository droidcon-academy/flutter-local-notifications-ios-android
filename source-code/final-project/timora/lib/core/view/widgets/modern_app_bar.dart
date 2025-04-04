import 'package:flutter/material.dart';

/// A modern app bar with a blur effect and transparent background.
///
/// This app bar extends behind the status bar and applies a blur effect to create
/// a sleek, modern look. It's designed to be used with pages that have a gradient
/// or image background.
class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title text to display in the app bar.
  final String title;

  /// Optional list of action widgets to display at the end of the app bar.
  final List<Widget>? actions;

  /// Optional leading widget to display at the start of the app bar.
  /// If null, a back button will be shown on pages that can be popped.
  final Widget? leading;

  /// Optional callback for when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// Creates a modern app bar with a blur effect.
  ///
  /// The [title] parameter is required and displayed as the app bar title.
  /// The [actions] parameter is optional and allows adding action buttons.
  /// The [leading] parameter is optional and allows customizing the leading widget.
  /// The [onBackPressed] parameter is optional and allows customizing the back button behavior.
  const ModernAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.8),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          letterSpacing: -0.5,
          color: theme.colorScheme.onSurface,
        ),
      ),
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface, size: 24),
      leading:
          leading ??
          (Navigator.canPop(context)
              ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
