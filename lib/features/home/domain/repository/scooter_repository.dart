import 'package:dartz/dartz.dart';
import 'package:escooter/features/home/domain/entity/scooter/scooter.dart';

abstract class ScooterRepository {
  Future<Either<String, List<Scooter>>> getScooters();
}
