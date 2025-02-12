// First, let's create a custom class to represent bottom navigation items
import 'package:escooter/common/router/app_router.dart';
import 'package:escooter/common/widgets/drawer/app_drawer.dart';
import 'package:escooter/core/configs/theme/app_styles.dart';
import 'package:escooter/features/home/presentation/widgets/bottom_sheet_content.dart';
import 'package:escooter/features/home/presentation/widgets/map_view.dart';
import 'package:escooter/features/home/presentation/widgets/search_modal.dart';
import 'package:escooter/features/notifications/presentation/modals/notification_modal.dart';
import 'package:escooter/features/theme/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomNavItem {
  final IconData icon;
  final String label;
  final String path;
  final String semanticLabel;

  const BottomNavItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.semanticLabel,
  });
}

class HomeScreen extends ConsumerWidget {
  // Define bottom navigation items
  final List<BottomNavItem> _navItems = const [
    BottomNavItem(
      icon: Icons.history,
      label: 'History',
      path: AppPaths.rideHistory,
      semanticLabel: 'Ride History',
    ),
    BottomNavItem(
      icon: Icons.electric_scooter,
      label: 'Rides',
      path: AppPaths.activeRide,
      semanticLabel: 'Active Ride',
    ),
    BottomNavItem(
      icon: Icons.account_balance_wallet,
      label: 'Wallet',
      path: AppPaths.wallet,
      semanticLabel: 'Wallet',
    ),
    BottomNavItem(
      icon: Icons.person,
      label: 'Profile',
      path: AppPaths.profile,
      semanticLabel: 'User Profile',
    ),
  ];

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(themeProvider).isDark;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_outlined,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const NotificationModal(),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => const SearchModal(),
              );
            },
          ),
        ],
      ),
      body: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned.fill(
              child: MapView(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: screenSize.height * 0.7,
                ),
                child: const BottomSheetContent(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, theme, isDarkMode),
      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: isDarkMode ? Colors.tealAccent : theme.primaryColor,
          foregroundColor: isDarkMode ? Colors.black : Colors.white,
          shape: const CircleBorder(),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_scanner),
            ],
          ),
          onPressed: () => context.go(AppPaths.scanner),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomBar(
      BuildContext context, ThemeData theme, bool isDarkMode) {
    return BottomAppBar(
      height: kBottomNavigationBarHeight + 35,
      elevation: 8,
      notchMargin: 8,
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const CircularNotchedRectangle(),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacing),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ..._navItems
                .take(2)
                .map((item) => _buildNavItem(context, item, theme, isDarkMode)),
            const SizedBox(width: 80),
            ..._navItems
                .skip(2)
                .map((item) => _buildNavItem(context, item, theme, isDarkMode)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    BottomNavItem item,
    ThemeData theme,
    bool isDarkMode,
  ) {
    return InkWell(
      onTap: () => context.push(item.path),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 24,
              color: isDarkMode ? Colors.white : Colors.black54,
              semanticLabel: item.semanticLabel,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDarkMode ? Colors.white : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
