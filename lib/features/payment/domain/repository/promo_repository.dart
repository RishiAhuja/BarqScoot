import 'package:dartz/dartz.dart';
import '../entities/promo_code.dart';

abstract class PromoRepository {
  Future<Either<String, PromoCode>> validatePromoCode(String code);
}
