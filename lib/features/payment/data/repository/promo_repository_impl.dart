import 'package:dartz/dartz.dart';
import 'package:escooter/core/error/api_exceptions.dart';
import '../service/promo_service.dart';
import '../../domain/repository/promo_repository.dart';
import '../../domain/entities/promo_code.dart';

class PromoRepositoryImpl implements PromoRepository {
  final PromoService _promoService;

  PromoRepositoryImpl(this._promoService);

  @override
  Future<Either<String, PromoCode>> validatePromoCode(String code) async {
    try {
      final promoData = await _promoService.validatePromoCode(code);
      return Right(PromoCode.fromJson(promoData));
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
