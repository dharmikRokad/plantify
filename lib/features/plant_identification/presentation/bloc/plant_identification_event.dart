part of 'plant_identification_bloc.dart';

sealed class PlantIdentificationEvent extends Equatable {
  const PlantIdentificationEvent();

  @override
  List<Object> get props => [];
}

class PlantIdentifyRequested extends PlantIdentificationEvent {
  const PlantIdentifyRequested(this.imagePath);

  final String imagePath;

  @override
  List<Object> get props => [imagePath];
}

class PlantHistoryRequested extends PlantIdentificationEvent {}

class PlantFavoriteToggled extends PlantIdentificationEvent {
  const PlantFavoriteToggled(this.scanId);

  final String scanId;

  @override
  List<Object> get props => [scanId];
}

class PlantScanDeleted extends PlantIdentificationEvent {
  const PlantScanDeleted(this.scanId);

  final String scanId;

  @override
  List<Object> get props => [scanId];
}