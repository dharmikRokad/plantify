import 'package:dartz/dartz.dart';
import 'package:myapp/core/errors/failures.dart';
import 'package:myapp/features/plant_identification/domain/entities/plant_scan.dart';

abstract class PlantIdentificationRepository {
  Future<Either<Failure, PlantScan>> identifyPlant(String imagePath);
  Future<Either<Failure, void>> savePlantScan(PlantScan scan);
  Future<Either<Failure, List<PlantScan>>> getPlantScans();
  Future<Either<Failure, void>> toggleFavorite(String scanId);
  Future<Either<Failure, void>> deletePlantScan(String scanId);
}