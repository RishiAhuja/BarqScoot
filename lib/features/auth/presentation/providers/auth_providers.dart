// lib/presentation/auth/providers/auth_providers.dart
import 'package:escooter/common/router/app_router.dart';
import 'package:escooter/core/di/service_locator/service_locator.dart';
import 'package:escooter/features/auth/domain/entities/create_user_request.dart';
import 'package:escooter/features/auth/domain/entities/login_request.dart';
// import 'package:escooter/features/auth/domain/entities/login_request.dart';
// import 'package:escooter/features/auth/domain/usecases/login_usecase.dart';
import 'package:escooter/features/auth/domain/usecases/login_with_phone_usecase.dart';
import 'package:escooter/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:escooter/features/auth/domain/usecases/save_user_usecase.dart';
import 'package:escooter/features/auth/domain/entities/verify_otp_params.dart';
import 'package:escooter/features/auth/domain/usecases/sent_otp_usecase.dart';
import 'package:escooter/features/auth/domain/usecases/verify_login_otp_usecase.dart';
import 'package:escooter/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:escooter/features/auth/presentation/providers/user_registeration_state.dart';
import 'package:escooter/utils/logger.dart';
// import 'package:escooter/features/auth/domain/entities/verify_otp_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

enum AuthMode { login, register }

final authModeProvider = StateProvider<AuthMode>((ref) => AuthMode.login);

@injectable
class AuthController extends StateNotifier<AsyncValue<void>> {
  final SendOtpUseCase _sendOtpUseCase;
  final RegisterUserUsecase _registerUserUsecase;
  final VerifyOtpUsecase _verifyOtpUsecase;
  final SaveUserUseCase _saveUserUsecase;
  final LoginWithPhoneUseCase
      _loginWithPhoneUseCase; // Changed from LoginUseCase
  final VerifyLoginOtpUseCase _verifyLoginOtpUseCase; // New use case

  // Store verification info between login steps
  String? _loginVerificationId;
  String? _loginPhoneNumber;

  AuthController(
    this._sendOtpUseCase,
    this._registerUserUsecase,
    this._verifyOtpUsecase,
    this._saveUserUsecase,
    this._loginWithPhoneUseCase,
    this._verifyLoginOtpUseCase,
  ) : super(const AsyncValue.data(null));

  Future<void> sendOTP(String phoneNumber, BuildContext context) async {
    state = const AsyncValue.loading();
    try {
      final result = await _sendOtpUseCase(params: phoneNumber);

      result.fold((l) {
        state = AsyncValue.error(l, StackTrace.current);
      }, (r) {
        state = const AsyncValue.data(null);
        if (context.mounted) {
          context.push('/auth/otp', extra: {'phoneNumber': phoneNumber});
        }
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> registerUserBackdoor(
      CreateUserRequest createUserRequest, BuildContext context) async {
    state = const AsyncValue.loading();
    Future.delayed(Duration(seconds: 2));
    context.push('/auth/otp',
        extra: {'phoneNumber': createUserRequest.phoneNumber});
  }

  Future<void> registerUser({
    required CreateUserRequest createUserRequest,
    required BuildContext context,
    required bool useBackdoor,
  }) async {
    state = const AsyncValue.loading();

    if (useBackdoor) {
      AppLogger.log('backdoor under use: @registeruser provider');
      return registerUserBackdoor(createUserRequest, context);
    } else {
      try {
        AppLogger.log('backdoor bypassed: @registeruser provider');
        final result = await _registerUserUsecase(params: createUserRequest);

        await result.fold(
          (failure) {
            AppLogger.error('Registration failed: ${failure.message}');
            state = AsyncValue.error(failure, StackTrace.current);
          },
          (success) async {
            AppLogger.log('Registration successful: $success');

            // Send OTP after successful registration
            final otpResult = await _sendOtpUseCase(
              params: createUserRequest.phoneNumber,
            );

            otpResult.fold(
              (otpFailure) {
                AppLogger.error('OTP send failed: ${otpFailure.message}');
                state = AsyncValue.error(otpFailure, StackTrace.current);
              },
              (otpSuccess) {
                AppLogger.log('OTP sent successfully: $otpSuccess');
                state = const AsyncValue.data(null);

                if (context.mounted) {
                  context.push('/auth/otp', extra: {
                    'phoneNumber': createUserRequest.phoneNumber,
                    'verificationId':
                        otpSuccess.verificationId, // Pass verification ID
                  });
                }
              },
            );
          },
        );
      } catch (e, stackTrace) {
        AppLogger.error('Unexpected error during registration: $e');
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }

  // Updated to handle verification ID
  Future<void> verifyOTP({
    required String phoneNumber,
    required String verificationId,
    required String otp,
    required BuildContext context,
    required UserRegistrationState registrationData,
  }) async {
    state = const AsyncValue.loading();
    try {
      final params = VerifyOtpParams(
        phoneNumber: phoneNumber,
        verificationId: verificationId,
        otp: otp,
      );
      final result = await _verifyOtpUsecase(params: params);

      result.fold(
        (failure) {
          AppLogger.error('OTP verification failed: ${failure.message}');
          state = AsyncValue.error(failure, StackTrace.current);
        },
        (success) async {
          AppLogger.log('OTP verified successfully: ${success.message}');
          final saveResult = await _saveUserUsecase(
            params: SaveUserParams(
              id: success.user.id,
              token: success.token,
              phoneNumber: registrationData.phoneNumber,
              firstName: registrationData.firstName,
              lastName: registrationData.lastName,
              dateOfBirth: registrationData.dateOfBirth,
              gender: registrationData.gender,
              isVerified: success.user.isVerified,
              walletBalance: 0,
              email: registrationData.email,
            ),
          );

          saveResult.fold(
            (failure) {
              state = AsyncValue.error(
                  failure?.toString() ?? 'Unexpected failure',
                  StackTrace.current);
            },
            (_) {
              state = const AsyncValue.data(null);
              if (context.mounted) {
                context.authenticateAndRedirect(); // Redirects to home
              }
            },
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during OTP verification: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Updated login method to initiate phone-based login
  Future<void> login({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();

    try {
      final result = await _loginWithPhoneUseCase(
        params: LoginRequest(phoneNumber: phoneNumber),
      );

      result.fold(
        (failure) {
          AppLogger.error('Login OTP request failed: $failure');
          state = AsyncValue.error(failure, StackTrace.current);
        },
        (otpResponse) {
          AppLogger.log('Login OTP sent successfully: ${otpResponse.message}');
          // Store verification data for the next step
          _loginVerificationId = otpResponse.verificationId;
          _loginPhoneNumber = phoneNumber;

          state = const AsyncValue.data(null);
          if (context.mounted) {
            // Pass both parameters when navigating
            context.push('/auth/login-otp', extra: {
              'phoneNumber': phoneNumber,
              'verificationId': otpResponse.verificationId,
            });
          }
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during login: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // New method to verify login OTP
  Future<void> verifyLoginOTP({
    required String otp,
    required BuildContext context,
  }) async {
    if (_loginVerificationId == null || _loginPhoneNumber == null) {
      state = AsyncValue.error(
          'Login session expired. Please try again.', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final result = await _verifyLoginOtpUseCase(
        params: VerifyOtpParams(
          phoneNumber: _loginPhoneNumber!,
          verificationId: _loginVerificationId!,
          otp: otp,
        ),
      );

      result.fold(
        (failure) {
          AppLogger.error('Login OTP verification failed: $failure');
          state = AsyncValue.error(failure, StackTrace.current);
        },
        (_) {
          AppLogger.log('Login successful');
          // Clear stored verification data
          _loginVerificationId = null;
          _loginPhoneNumber = null;

          state = const AsyncValue.data(null);
          if (context.mounted) {
            context.authenticateAndRedirect();
          }
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during login OTP verification: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Provider now uses GetIt to create the controller
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return getIt<AuthController>();
});
