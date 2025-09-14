import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:myapp/core/errors/failures.dart';
import 'package:myapp/features/plant_identification/data/datasources/plant_identification_local_data_source.dart';
import 'package:myapp/features/plant_identification/data/datasources/plant_identification_remote_data_source.dart';
import 'package:myapp/features/plant_identification/data/models/plant_scan_model.dart';
import 'package:myapp/features/plant_identification/domain/entities/plant_scan.dart';
import 'package:myapp/features/plant_identification/domain/repositories/plant_identification_repository.dart';

class PlantIdentificationRepositoryImpl
    implements PlantIdentificationRepository {
  final PlantIdentificationLocalDataSource localDataSource;
  final PlantIdentificationRemoteDataSource remoteDataSource;

  PlantIdentificationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, PlantScan>> identifyPlant(Uint8List image) async {
    try {
      final plant = await remoteDataSource.identifyPlant(image);
      return Right(plant);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> savePlantScan(PlantScan scan) async {
    try {
      final model = PlantScanModel.fromEntity(scan);
      await localDataSource.savePlantScan(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlantScan>>> getPlantScans() async {
    try {
      final models = await localDataSource.getPlantScans();
      return Right(models);
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
