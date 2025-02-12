import 'package:flutter/material.dart';

class SearchModal extends StatelessWidget {
  const SearchModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search location',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('Battery > 50%'),
                onSelected: (_) {},
              ),
              FilterChip(
                label: const Text('Within 1km'),
                onSelected: (_) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
