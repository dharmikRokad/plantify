import 'package:equatable/equatable.dart';

class PlantScan extends Equatable {
  const PlantScan({
    required this.id,
    required this.imagePath,
    required this.plantName,
    required this.scientificName,
    required this.description,
    required this.careInstructions,
    required this.confidence,
    required this.timestamp,
    this.isFavorite = false,
    this.commonNames,
    this.family,
    this.origin,
  });

  final String id;
  final String imagePath;
  final String plantName;
  final String scientificName;
  final String description;
  final String careInstructions;
  final double confidence;
  final DateTime timestamp;
  final bool isFavorite;
  final List<String>? commonNames;
  final String? family;
  final String? origin;

  PlantScan copyWith({
    String? id,
    String? imagePath,
    String? plantName,
    String? scientificName,
    String? description,
    String? careInstructions,
    double? confidence,
    DateTime? timestamp,
    bool? isFavorite,
    List<String>? commonNames,
    String? family,
    String? origin,
  }) => PlantScan(
    id: id ?? this.id,
    imagePath: imagePath ?? this.imagePath,
    plantName: plantName ?? this.plantName,
    scientificName: scientificName ?? this.scientificName,
    description: description ?? this.description,
    careInstructions: careInstructions ?? this.careInstructions,
    confidence: confidence ?? this.confidence,
    timestamp: timestamp ?? this.timestamp,
    isFavorite: isFavorite ?? this.isFavorite,
    commonNames: commonNames ?? this.commonNames,
    family: family ?? this.family,
    origin: origin ?? this.origin,
  );

  @override
  List<Object> get props => [
    id, imagePath, plantName, scientificName, description,
    careInstructions, confidence, timestamp, isFavorite,
    commonNames ?? [], family ?? '', origin ?? '',
  ];
}