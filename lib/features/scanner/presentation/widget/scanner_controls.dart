import 'package:flutter/material.dart';

class ScannerControls extends StatelessWidget {
  final bool isTorchOn;
  final VoidCallback onTorchPressed;
  final VoidCallback onManualEntryPressed;

  const ScannerControls({
    super.key,
    required this.isTorchOn,
    required this.onTorchPressed,
    required this.onManualEntryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Scan QR Code',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  isTorchOn ? Icons.flash_on : Icons.flash_off,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: onTorchPressed,
              ),
              TextButton(
                onPressed: onManualEntryPressed,
                child: const Text('Enter Code Manually'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
