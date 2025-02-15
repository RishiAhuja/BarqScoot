import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final int totalRides;
  final Duration totalTime;
  final bool isDarkMode;

  const StatsCard({
    super.key,
    required this.totalRides,
    required this.totalTime,
    required this.isDarkMode,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              icon: Icons.electric_scooter,
              value: totalRides.toString(),
              label: 'Total Rides',
              isDarkMode: isDarkMode,
            ),
            Container(
              height: 40,
              width: 1,
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
            ),
            _StatItem(
              icon: Icons.timer_outlined,
              value: _formatDuration(totalTime),
              label: 'Total Time',
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isDarkMode;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isDarkMode ? Colors.teal[300] : Colors.teal,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
