import 'package:dartz/dartz.dart';
import 'package:escooter/core/configs/services/storage/storage_service.dart';
import 'package:escooter/core/error/api_exceptions.dart';
import 'package:escooter/features/auth/data/models/login_reponse.dart';
import 'package:escooter/features/auth/data/models/otp_response.dart';
import 'package:escooter/features/auth/data/sources/auth_service.dart';
import 'package:escooter/features/auth/domain/entities/create_user_request.dart';
import 'package:escooter/features/auth/domain/entities/login_request.dart';
import 'package:escooter/features/auth/domain/entities/verify_otp_response.dart';
import 'package:escooter/features/auth/domain/repository/auth_repository.dart';
import 'package:escooter/features/auth/domain/usecases/save_user_usecase.dart';
import 'package:escooter/features/home/data/model/user_model.dart';
import 'package:escooter/utils/logger.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;
  final StorageService _storageService;

  AuthRepositoryImpl(
    @Named('authApiService') this._authApiService,
    this._storageService,
  );

  @override
  Future<Either<AuthException, OtpResponse>> sendOtp(String phoneNumber) async {
    try {
      final result = await _authApiService.sendOtp(phoneNumber);

      return result.fold(
        (apiException) => Left(AuthException(apiException.message)),
        (json) {
          try {
            // Even if OTP is sent successfully but we got error in response
            if (json['error'] != null) {
              return Left(AuthException(json['error']));
            }

            final otpResponse = OtpResponse.fromJson(json);
            return Right(otpResponse);
          } catch (e) {
            AppLogger.error('Error parsing OTP response: $e');
            return Left(AuthException('Invalid response format'));
          }
        },
      );
    } catch (e) {
      AppLogger.error('Repository error sending OTP: $e');
      return Left(AuthException('Unexpected error'));
    }
  }

  @override
  Future<Either<AuthException, VerifyOtpResponse>> verifyOtp(
    String phoneNumber,
    String otp,
  ) async {
    try {
      final result = await _authApiService.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );

      return result.fold(
        (apiException) => Left(AuthException(apiException.message)),
        (json) {
          try {
            if (json['error'] != null) {
              return Left(AuthException(json['error']));
            }

            final verifyOtpResponse = VerifyOtpResponse.fromJson(json);
            return Right(verifyOtpResponse);
          } catch (e) {
            AppLogger.error('Error parsing verify OTP response: $e');
            return Left(AuthException('Invalid response format'));
          }
        },
      );
    } catch (e) {
      AppLogger.error('Repository error verifying OTP: $e');
      return Left(AuthException('Unexpected error'));
    }
  }

  @override
  Future<Either<AuthException, String>> registerUser(
      CreateUserRequest createUserRequest) async {
    try {
      final result = await _authApiService.registerUser(createUserRequest);
      return result.fold(
        (apiException) {
          AppLogger.log(
              "From auth repository implementation: ${apiException.message}");
          AppLogger.error(apiException.message);
          return Left(AuthException(apiException.message));
        },
        (json) {
          try {
            AppLogger.log(json['message']);
            return Right(json['message']);
          } catch (e) {
            AppLogger.error('Invalid response');
            return Left(AuthException('Invalid response'));
          }
        },
      );
    } catch (e) {
      AppLogger.error('Unexpected error: $e');
      return Left(AuthException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<AuthException, void>> saveUser(SaveUserParams params) async {
    try {
      final user = UserModel(
        id: params.id,
        token: params.token,
        phoneNumber: params.phoneNumber,
        firstName: params.firstName,
        lastName: params.lastName,
        dateOfBirth: params.dateOfBirth,
        gender: params.gender,
        isVerified: params.isVerified,
        email: params.email,
        walletBalance: params.walletBalance,
        createdAt: DateTime.now(),
      );

      await _storageService.saveUser(user);
      AppLogger.log('User data saved successfully');
      return const Right(null);
    } catch (e) {
      AppLogger.error('Error saving user data: $e');
      return Left(AuthException('Failed to save user data'));
    }
  }

  @override
  Future<Either<String, LoginResponse>> login(LoginRequest request) async {
    try {
      final result = await _authApiService.login(request);
      return Right(LoginResponse.fromJson(result));
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left('Unexpected error during login: $e');
    }
  }

  @override
  Future<Either<String, UserModel>> getUserProfile(String token) async {
    try {
      final result = await _authApiService.getUserProfile(token);
      final userData = result['data'];
      return Right(UserModel.fromJson(userData));
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left('Failed to get user profile: $e');
    }
  }
}
