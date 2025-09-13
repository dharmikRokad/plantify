part of 'plant_identification_bloc.dart';

sealed class PlantIdentificationState extends Equatable {
  const PlantIdentificationState();
  
  @override
  List<Object> get props => [];
}

class PlantIdentificationInitial extends PlantIdentificationState {}

class PlantIdentificationLoading extends PlantIdentificationState {}

class PlantIdentificationSuccess extends PlantIdentificationState {
  const PlantIdentificationSuccess(this.scan);

  final PlantScan scan;

  @override
  List<Object> get props => [scan];
}

class PlantIdentificationError extends PlantIdentificationState {
  const PlantIdentificationError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class PlantHistoryLoading extends PlantIdentificationState {}

class PlantHistoryLoaded extends PlantIdentificationState {
  const PlantHistoryLoaded(this.scans);

  final List<PlantScan> scans;

  @override
  List<Object> get props => [scans];
}

class PlantHistoryError extends PlantIdentificationState {
  const PlantHistoryError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}