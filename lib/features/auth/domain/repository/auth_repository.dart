import 'package:dartz/dartz.dart';
import 'package:escooter/features/auth/domain/entities/create_user_request.dart';
import 'package:escooter/features/auth/domain/entities/login_request.dart';
import 'package:escooter/features/auth/domain/usecases/save_user_usecase.dart';

abstract class AuthRepository {
  Future<Either> registerUser(CreateUserRequest phoneNumber);
  Future<Either> sendOtp(String phoneNumber);
  Future<Either> verifyOtp(String phoneNumber, String otp);
  Future<Either> saveUser(SaveUserParams params);
  Future<Either> login(LoginRequest request);
  Future<Either> getUserProfile(String token);
}
