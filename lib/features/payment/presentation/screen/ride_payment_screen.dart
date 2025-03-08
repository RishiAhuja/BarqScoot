import 'package:escooter/core/configs/theme/app_colors.dart';
import 'package:escooter/features/payment/domain/entities/promo_code.dart';
import 'package:escooter/features/payment/presentation/providers/promo_provider.dart';
import 'package:flutter/material.dart';
import 'package:escooter/features/rides/data/model/ride_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RidePaymentScreen extends ConsumerStatefulWidget {
  final Ride ride;

  const RidePaymentScreen({
    super.key,
    required this.ride,
  });

  @override
  ConsumerState<RidePaymentScreen> createState() => _RidePaymentScreenState();
}

class _RidePaymentScreenState extends ConsumerState<RidePaymentScreen> {
  final _promoController = TextEditingController();
  bool _isApplyingPromo = false;
  // double? _discountedPrice;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _applyPromoCode() async {
    if (_promoController.text.isEmpty) return;

    setState(() {
      _isApplyingPromo = true;
    });

    try {
      // Call the promo code provider
      await ref.read(promoCodeProvider.notifier).validatePromoCode(
            _promoController.text.toUpperCase(),
          );
    } finally {
      if (mounted) {
        setState(() {
          _isApplyingPromo = false;
        });
      }
    }
  }

  double _calculateDiscountedPrice(PromoCode promoCode) {
    final originalPrice = widget.ride.totalPrice ?? 0;
    final discountAmount = (originalPrice * promoCode.discountPercent) / 100;

    // Apply max discount cap
    final actualDiscount = discountAmount > promoCode.maxDiscount
        ? promoCode.maxDiscount
        : discountAmount;

    return originalPrice - actualDiscount;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Watch the promo code state
    final promoState = ref.watch(promoCodeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: colorScheme.outline.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Amount to Pay',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      promoState.when(
                        data: (promoCode) {
                          if (promoCode != null) {
                            final discountedPrice =
                                _calculateDiscountedPrice(promoCode);
                            return Column(
                              children: [
                                Text(
                                  'SR ${(widget.ride.totalPrice ?? 0).toStringAsFixed(2)}',
                                  style: textTheme.bodyLarge?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'SR ${discountedPrice.toStringAsFixed(2)}',
                                  style: textTheme.headlineMedium?.copyWith(
                                    color: AppColors.primaryTeal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${promoCode.discountPercent}% discount applied',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          }
                          return Text(
                            'SR ${(widget.ride.totalPrice ?? 0).toStringAsFixed(2)}',
                            style: textTheme.headlineMedium?.copyWith(
                              color: AppColors.primaryTeal,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) => Text(
                          'SR ${(widget.ride.totalPrice ?? 0).toStringAsFixed(2)}',
                          style: textTheme.headlineMedium?.copyWith(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: colorScheme.outline.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Promo Code',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              // Using bodyMedium for input text to match app style
                              style: textTheme.bodyMedium,
                              decoration: InputDecoration(
                                hintText: 'Enter code',
                                hintStyle: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: colorScheme.outline,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed:
                                _isApplyingPromo ? null : _applyPromoCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryTeal,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isApplyingPromo
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Apply',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Methods',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _PaymentButton(
                icon: Icons.account_balance_wallet,
                text: 'Pay with Wallet',
                onPressed: () {},
                textTheme: textTheme,
              ),
              const SizedBox(height: 12),
              _PaymentButton(
                icon: Icons.android,
                text: 'Pay with Google Pay',
                onPressed: () {},
                textTheme: textTheme,
              ),
              const SizedBox(height: 12),
              _PaymentButton(
                icon: Icons.apple,
                text: 'Pay with Apple Pay',
                onPressed: () {},
                textTheme: textTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final TextTheme textTheme;

  const _PaymentButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.textTheme,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryTeal,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
