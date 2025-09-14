import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/core/errors/failures.dart';
import 'package:myapp/core/usecases/usecase.dart';
import 'package:myapp/features/plant_identification/domain/entities/plant_scan.dart';
import 'package:myapp/features/plant_identification/domain/repositories/plant_identification_repository.dart';

class IdentifyPlant implements UseCase<PlantScan, IdentifyPlantParams> {
  const IdentifyPlant(this.repository);

  final PlantIdentificationRepository repository;

  @override
  Future<Either<Failure, PlantScan>> call(IdentifyPlantParams params) async {
    final result = await repository.identifyPlant(params.imageBytes);
    return result.fold(
      (failure) => Left(failure),
      (scan) async {
        await repository.savePlantScan(scan);
        return Right(scan);
      },
    );
  }
}

class IdentifyPlantParams extends Equatable {
  const IdentifyPlantParams({required this.imageBytes});

  final Uint8List imageBytes;

  @override
  List<Object> get props => [imageBytes];
}