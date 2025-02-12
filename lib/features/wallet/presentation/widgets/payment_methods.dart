import 'package:escooter/core/configs/theme/app_colors.dart';
import 'package:escooter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/configs/constants/app_localization_constants.dart';

class PaymentMethods extends ConsumerWidget {
  final bool isDarkMode;

  const PaymentMethods({required this.isDarkMode, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = ref.watch(appLocalizationsProvider);
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations
                    .translate(AppLocalizationConstants.paymentMethods),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Show all payment methods
                },
                child: Text(
                  localizations.translate(AppLocalizationConstants.seeAll),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            index == 0 ? Icons.credit_card : Icons.payment,
                            color: isDarkMode
                                ? AppColors.primaryTeal
                                : theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                index == 0
                                    ? 'Visa •••• 1234'
                                    : 'Mastercard •••• 5678',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                index == 0 ? 'Expires 12/24' : 'Expires 09/25',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color:
                                isDarkMode ? Colors.white70 : Colors.grey[700],
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement add card
            },
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  isDarkMode ? Colors.white : theme.colorScheme.primary,
              side: BorderSide(
                color: isDarkMode ? Colors.white70 : theme.colorScheme.primary,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(
              Icons.add,
              color: isDarkMode ? Colors.white : theme.colorScheme.primary,
            ),
            label: Text(
              localizations
                  .translate(AppLocalizationConstants.addNewPaymentMethod),
              style: TextStyle(
                color: isDarkMode ? Colors.white : theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
