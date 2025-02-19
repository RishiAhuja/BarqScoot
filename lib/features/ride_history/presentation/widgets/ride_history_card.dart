import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RideHistoryCard extends StatelessWidget {
  final DateTime date;
  final String startLocation;
  final String endLocation;
  final Duration duration;
  final double cost;
  final VoidCallback onTap;
  final bool isDarkMode;

  const RideHistoryCard({
    super.key,
    required this.date,
    required this.startLocation,
    required this.endLocation,
    required this.duration,
    required this.cost,
    required this.onTap,
    required this.isDarkMode,
  });

  String _formatLocation(String location) {
    try {
      final coordinates = location.split(',');
      final lat = double.parse(coordinates[0]).toStringAsFixed(2);
      final lng = double.parse(coordinates[1]).toStringAsFixed(2);
      return '$lat, $lng';
    } catch (e) {
      return location;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMM d, yyyy').format(date),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              _buildLocationRow(
                icon: Icons.location_on,
                text: _formatLocation(startLocation),
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 4),
              _buildLocationRow(
                icon: Icons.location_on_outlined,
                text: _formatLocation(endLocation),
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${duration.inMinutes} mins',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  Text(
                    '﷼${cost.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required String text,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
