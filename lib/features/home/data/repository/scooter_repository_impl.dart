import 'package:dartz/dartz.dart';
import 'package:escooter/features/home/data/service/scooter_service.dart';
import 'package:escooter/features/home/domain/entity/scooter/scooter.dart';
import 'package:escooter/features/home/domain/repository/scooter_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ScooterRepository)
class ScooterRepositoryImpl implements ScooterRepository {
  final ScooterService _scooterService;

  ScooterRepositoryImpl(this._scooterService);

  @override
  Future<Either<String, List<Scooter>>> getScooters() async {
    try {
      final result = await _scooterService.getScooters();
      final scooters = result.map((json) => Scooter.fromJson(json)).toList();
      return Right(scooters);
    } catch (e) {
      return Left('Failed to get scooters: $e');
    }
  }
}
