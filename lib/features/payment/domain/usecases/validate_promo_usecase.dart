import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/promo_repository.dart';

class ValidatePromoCode implements Usecase<Either, String> {
  final PromoRepository repository;

  ValidatePromoCode(this.repository);

  @override
  Future<Either> call({String? params}) {
    return repository.validatePromoCode(params!);
  }
}
