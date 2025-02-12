import 'package:escooter/features/ride_history/presentation/widgets/ride_history_card.dart';
import 'package:escooter/features/theme/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RideHistoryScreen extends ConsumerWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDark;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text(
          'Ride History',
          style: theme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w200,
            fontSize: 20,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.filter_list,
        //       color: isDarkMode ? Colors.white : Colors.black87,
        //     ),
        //     onPressed: () {
        //       // TODO: Show filter options
        //     },
        //   ),
        // ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // Replace with actual ride history
        itemBuilder: (context, index) {
          return RideHistoryCard(
            date: DateTime.now().subtract(Duration(days: index)),
            startLocation: '123 Main St',
            endLocation: '456 Park Ave',
            duration: const Duration(minutes: 15),
            cost: 5.99,
            onTap: () {},
            isDarkMode: isDarkMode,
          );
        },
      ),
    );
  }
}
