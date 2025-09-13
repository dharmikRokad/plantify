import 'package:dartz/dartz.dart';
import 'package:myapp/core/errors/failures.dart';
import 'package:myapp/features/plant_identification/data/datasources/plant_identification_local_data_source.dart';
import 'package:myapp/features/plant_identification/data/datasources/plant_identification_remote_data_source.dart';
import 'package:myapp/features/plant_identification/data/models/plant_scan_model.dart';
import 'package:myapp/features/plant_identification/domain/entities/plant_scan.dart';
import 'package:myapp/features/plant_identification/domain/repositories/plant_identification_repository.dart';

class PlantIdentificationRepositoryImpl implements PlantIdentificationRepository {
  PlantIdentificationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final PlantIdentificationRemoteDataSource remoteDataSource;
  final PlantIdentificationLocalDataSource localDataSource;

  @override
  Future<Either<Failure, PlantScan>> identifyPlant(String imagePath) async {
    try {
      final scan = await remoteDataSource.identifyPlant(imagePath);
      return Right(scan);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> savePlantScan(PlantScan scan) async {
    try {
      final scanModel = scan is PlantScanModel 
          ? scan 
          : PlantScanModel.fromEntity(scan);
      await localDataSource.savePlantScan(scanModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlantScan>>> getPlantScans() async {
    try {
      final scans = await localDataSource.getPlantScans();
      return Right(scans);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String scanId) async {
    try {
      await localDataSource.toggleFavorite(scanId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlantScan(String scanId) async {
    try {
      await localDataSource.deletePlantScan(scanId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}