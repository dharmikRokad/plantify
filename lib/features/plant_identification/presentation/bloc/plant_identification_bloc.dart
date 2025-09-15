import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/features/plant_identification/domain/entities/plant_scan.dart';
import 'package:myapp/features/plant_identification/domain/usecases/identify_plant.dart';
import 'package:myapp/features/plant_identification/domain/repositories/plant_identification_repository.dart';

part 'plant_identification_event.dart';
part 'plant_identification_state.dart';

class PlantIdentificationBloc
    extends Bloc<PlantIdentificationEvent, PlantIdentificationState> {
  PlantIdentificationBloc({
    required this.identifyPlant,
    required this.repository,
  }) : super(PlantIdentificationInitial()) {
    on<PlantIdentifyRequested>(_onIdentifyRequested);
    on<PlantHistoryRequested>(_onHistoryRequested);
    on<PlantFavoriteToggled>(_onFavoriteToggled);
    on<PlantScanDeleted>(_onScanDeleted);
  }

  final IdentifyPlant identifyPlant;
  final PlantIdentificationRepository repository;

  Future<void> _onIdentifyRequested(
    PlantIdentifyRequested event,
    Emitter<PlantIdentificationState> emit,
  ) async {
    emit(PlantIdentificationLoading());

    final result = await identifyPlant(
      IdentifyPlantParams(imageBytes: event.imageBytes),
    );

    result.fold(
      (failure) => emit(PlantIdentificationError(failure.message)),
      (scan) => emit(PlantIdentificationSuccess(scan)),
    );
  }

  Future<void> _onHistoryRequested(
    PlantHistoryRequested event,
    Emitter<PlantIdentificationState> emit,
  ) async {
    emit(PlantHistoryLoading());

    final result = await repository.getPlantScans();

    result.fold(
      (failure) => emit(PlantHistoryError(failure.message)),
      (scans) => emit(PlantHistoryLoaded(scans)),
    );
  }

  Future<void> _onFavoriteToggled(
    PlantFavoriteToggled event,
    Emitter<PlantIdentificationState> emit,
  ) async {
    final result = await repository.toggleFavorite(event.scanId);

    result.fold(
      (failure) => emit(PlantIdentificationError(failure.message)),
      (_) => add(PlantHistoryRequested()),
    );
  }

  Future<void> _onScanDeleted(
    PlantScanDeleted event,
    Emitter<PlantIdentificationState> emit,
  ) async {
    final result = await repository.deletePlantScan(event.scanId);

    result.fold(
      (failure) => emit(PlantIdentificationError(failure.message)),
      (_) => add(PlantHistoryRequested()),
    );
  }
}
