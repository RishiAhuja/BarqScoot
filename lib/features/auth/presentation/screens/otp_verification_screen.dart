import 'package:escooter/core/configs/constants/app_localization_constants.dart';
import 'package:escooter/core/configs/theme/app_colors.dart';
import 'package:escooter/features/auth/presentation/providers/auth_providers.dart';
import 'package:escooter/features/auth/presentation/providers/user_registeration_state.dart';
import 'package:escooter/l10n/app_localizations.dart';
import 'package:escooter/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final _otpController = TextEditingController();
  int _remainingTime = 30;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start animation immediately
    _animationController.forward();
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_remainingTime > 0) _remainingTime--;
      });
      return _remainingTime > 0;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerifyOtp() {
    final otp = _otpController.text;
    if (otp.length != 6) return;

    AppLogger.log('otp: $otp');
    final registrationData = ref.read(userRegistrationProvider);
    if (registrationData == null) {
      AppLogger.error('Registration data is null');
      return;
    }

    ref.read(authControllerProvider.notifier).verifyOTP(
          phoneNumber: widget.phoneNumber,
          otp: otp,
          context: context,
          registrationData: registrationData,
        );
  }

  @override
  Widget build(BuildContext context) {
    final translations = ref.watch(appLocalizationsProvider);
    final authState = ref.watch(authControllerProvider);
    final isVerifying = authState.isLoading;

    ref.listen<AsyncValue>(
      authControllerProvider,
      (_, state) {
        state.whenOrNull(
          error: (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.primaryTeal,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translations.translate(
                                    AppLocalizationConstants.verifyOTP),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryTeal),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                translations.translate(
                                    AppLocalizationConstants.otpSentTo),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.phoneNumber,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Pinput(
                      length: 6,
                      controller: _otpController,
                      defaultPinTheme: PinTheme(
                        width: 50,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 50,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      onCompleted: (_) => _handleVerifyOtp(),
                      // separator: const SizedBox(width: 12),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: _remainingTime > 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$_remainingTime ${translations.translate(AppLocalizationConstants.seconds)}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                        : TextButton.icon(
                            onPressed: () {
                              setState(() => _remainingTime = 30);
                              _startTimer();
                              // Implement resend logic
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(
                              translations.translate(
                                  AppLocalizationConstants.resendOtp),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryTeal),
                            ),
                          ),
                  ),
                  const Spacer(),
                  Container(
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: isVerifying ? null : _handleVerifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isVerifying
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              translations.translate(
                                  AppLocalizationConstants.verifyOtp),
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
