// lib/presentation/wallet/screens/wallet_screen.dart
import 'package:escooter/features/theme/presentation/providers/theme_provider.dart';
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BalanceCard(isDarkMode: isDarkMode),
            PaymentMethods(isDarkMode: isDarkMode),
            // TransactionList(isDarkMode: isDarkMode),
          ],
        ),
      ),
    );
  }
}
