import 'package:flutter/material.dart';
import 'package:timora/core/router/app_routes_enum.dart';

class TimoraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const TimoraAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      actions:
          actions ??
          [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
              onPressed:
                  () => Navigator.pushNamed(context, AppRoutes.settings.value),
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
