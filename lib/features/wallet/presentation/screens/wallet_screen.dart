import 'package:escooter/features/theme/presentation/providers/theme_provider.dart';
import 'package:escooter/features/wallet/presentation/providers/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/balance_card.dart';
import '../widgets/payment_methods.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDark;
    final theme = Theme.of(context);
    final balanceAsync = ref.watch(balanceProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
        title: Text(
          'My Wallet',
          style: theme.textTheme.titleLarge?.copyWith(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        actions: [
          IconButton(
            onPressed: () => ref.refresh(balanceProvider),
            icon: Icon(
              Icons.refresh,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.history,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            onPressed: () {
              // TODO: Show transaction history
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(balanceProvider.future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              balanceAsync.when(
                data: (balance) => BalanceCard(
                  isDarkMode: isDarkMode,
                  balance: balance,
                ),
                loading: () => const BalanceCardSkeleton(),
                error: (error, stack) => BalanceErrorCard(
                  isDarkMode: isDarkMode,
                  error: error.toString(),
                  onRetry: () => ref.refresh(balanceProvider),
                ),
              ),
              PaymentMethods(isDarkMode: isDarkMode),
            ],
          ),
        ),
      ),
    );
  }
}

class BalanceCardSkeleton extends StatelessWidget {
  const BalanceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(24),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class BalanceErrorCard extends StatelessWidget {
  final bool isDarkMode;
  final String error;
  final VoidCallback onRetry;

  const BalanceErrorCard({
    super.key,
    required this.isDarkMode,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load balance',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
