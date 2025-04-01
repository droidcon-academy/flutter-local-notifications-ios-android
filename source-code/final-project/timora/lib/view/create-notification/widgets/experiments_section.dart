import 'package:flutter/material.dart';

class ExperimentsSection extends StatelessWidget {
  final VoidCallback onProgressTest;
  final VoidCallback onGroupTest;

  const ExperimentsSection({
    super.key,
    required this.onProgressTest,
    required this.onGroupTest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const Text(
          'Try special notification types instantly',
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.downloading),
                label: const Text('TEST PROGRESS'),
                onPressed: onProgressTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.format_list_bulleted),
                label: const Text('TEST GROUP'),
                onPressed: onGroupTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.tertiary,
                  foregroundColor: theme.colorScheme.onTertiary,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Note: These notifications will appear immediately with the currently selected category',
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
