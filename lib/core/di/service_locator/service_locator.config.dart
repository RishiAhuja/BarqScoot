// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

import '../../../features/auth/data/repository/auth_repository_impl.dart'
    as _i67;
import '../../../features/auth/data/sources/auth_service.dart' as _i780;
import '../../../features/auth/domain/repository/auth_repository.dart' as _i754;
import '../../../features/auth/domain/usecases/login_usecase.dart' as _i849;
import '../../../features/auth/domain/usecases/register_user_usecase.dart'
    as _i635;
import '../../../features/auth/domain/usecases/save_user_usecase.dart' as _i388;
import '../../../features/auth/domain/usecases/sent_otp_usecase.dart' as _i591;
import '../../../features/auth/domain/usecases/verify_otp_usecase.dart'
    as _i553;
import '../../../features/auth/presentation/providers/auth_providers.dart'
    as _i832;
import '../../../features/home/data/repository/scooter_repository_impl.dart'
    as _i820;
import '../../../features/home/data/service/scooter_service.dart' as _i564;
import '../../../features/home/domain/repository/scooter_repository.dart'
    as _i136;
import '../../../features/rides/data/repository/ride_repo_impl.dart' as _i953;
import '../../../features/rides/data/service/location_service.dart' as _i804;
import '../../../features/rides/data/service/ride_service.dart' as _i417;
import '../../../features/rides/domain/repository/ride_repository.dart'
    as _i152;
import '../../../features/rides/domain/usecases/end_ride_usecase.dart' as _i810;
import '../../../features/rides/domain/usecases/start_ride_usecase.dart'
    as _i841;
import '../../../features/wallet/data/repository/wallet_repo_impl.dart'
    as _i1042;
import '../../../features/wallet/data/service/wallet_service.dart' as _i1019;
import '../../../features/wallet/domain/repository/wallet_repository.dart'
    as _i849;
import '../../../features/wallet/domain/usecases/add_money_usecase.dart'
    as _i826;
import '../../../features/wallet/domain/usecases/get_balance_usecase.dart'
    as _i390;
import '../../configs/services/storage/storage_service.dart' as _i318;
import '../modules/network_module.dart' as _i184;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i804.LocationService>(() => _i804.LocationService());
    gh.singleton<_i318.StorageService>(() => _i318.StorageService());
    gh.singleton<_i519.Client>(
      () => registerModule.httpClient,
      instanceName: 'httpClient',
    );
    gh.factory<_i417.RideService>(() => _i417.RideService(
          gh<_i519.Client>(instanceName: 'httpClient'),
          gh<_i318.StorageService>(),
        ));
    gh.factory<_i564.ScooterService>(() => _i564.ScooterService(
          gh<_i519.Client>(instanceName: 'httpClient'),
          gh<_i318.StorageService>(),
        ));
    gh.lazySingleton<_i1019.WalletService>(() => _i1019.WalletService(
          gh<_i519.Client>(instanceName: 'httpClient'),
          gh<_i318.StorageService>(),
        ));
    gh.lazySingleton<_i849.WalletRepository>(
        () => _i1042.WalletRepositoryImpl(gh<_i1019.WalletService>()));
    gh.factory<_i780.AuthApiService>(
      () => _i780.AuthApiService(gh<_i519.Client>(instanceName: 'httpClient')),
      instanceName: 'authApiService',
    );
    gh.factory<_i152.RideRepository>(() => _i953.RideRepositoryImpl(
          gh<_i417.RideService>(),
          gh<_i804.LocationService>(),
        ));
    gh.factory<_i810.EndRideUseCase>(() => _i810.EndRideUseCase(
          gh<_i152.RideRepository>(),
          gh<_i804.LocationService>(),
        ));
    gh.factory<_i841.StartRideUseCase>(() => _i841.StartRideUseCase(
          gh<_i152.RideRepository>(),
          gh<_i804.LocationService>(),
        ));
    gh.factory<_i390.GetBalanceUseCase>(
        () => _i390.GetBalanceUseCase(gh<_i849.WalletRepository>()));
    gh.factory<_i826.AddMoneyUseCase>(
        () => _i826.AddMoneyUseCase(gh<_i849.WalletRepository>()));
    gh.factory<_i136.ScooterRepository>(
        () => _i820.ScooterRepositoryImpl(gh<_i564.ScooterService>()));
    gh.factory<_i754.AuthRepository>(() => _i67.AuthRepositoryImpl(
          gh<_i780.AuthApiService>(instanceName: 'authApiService'),
          gh<_i318.StorageService>(),
        ));
    gh.factory<_i553.VerifyOtpUsecase>(
        () => _i553.VerifyOtpUsecase(gh<_i754.AuthRepository>()));
    gh.factory<_i591.SendOtpUseCase>(
        () => _i591.SendOtpUseCase(gh<_i754.AuthRepository>()));
    gh.factory<_i635.RegisterUserUsecase>(
        () => _i635.RegisterUserUsecase(gh<_i754.AuthRepository>()));
    gh.factory<_i388.SaveUserUseCase>(
        () => _i388.SaveUserUseCase(gh<_i754.AuthRepository>()));
    gh.factory<_i849.LoginUseCase>(() => _i849.LoginUseCase(
          gh<_i754.AuthRepository>(),
          gh<_i318.StorageService>(),
        ));
    gh.factory<_i832.AuthController>(() => _i832.AuthController(
          gh<_i591.SendOtpUseCase>(),
          gh<_i635.RegisterUserUsecase>(),
          gh<_i553.VerifyOtpUsecase>(),
          gh<_i388.SaveUserUseCase>(),
          gh<_i849.LoginUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i184.RegisterModule {}
