import 'package:myapp/features/plant_identification/domain/entities/plant_scan.dart';

class PlantScanModel extends PlantScan {
  const PlantScanModel({
    required super.id,
    required super.imagePath,
    required super.plantName,
    required super.scientificName,
    required super.description,
    required super.careInstructions,
    required super.confidence,
    required super.timestamp,
    super.isFavorite = false,
    super.commonNames,
    super.family,
    super.origin,
  });

  factory PlantScanModel.fromJson(Map<String, dynamic> json) => PlantScanModel(
    id: json['id'] ?? DateTime.now().toIso8601String(),
    imagePath: json['imagePath'] ?? '',
    plantName: json['plantName'] as String,
    scientificName: json['scientificName'] as String,
    description: json['description'] as String,
    careInstructions: json['careInstructions'] as String,
    confidence: (json['confidence'] ?? 0.0).toDouble(),
    timestamp: json['timestamp'] == null
        ? DateTime.now()
        : DateTime.parse(json['timestamp']),
    isFavorite: json['isFavorite'] as bool? ?? false,
    commonNames: (json['commonNames'] as List<dynamic>?)?.cast<String>(),
    family: json['family'] as String?,
    origin: json['origin'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'imagePath': imagePath,
    'plantName': plantName,
    'scientificName': scientificName,
    'description': description,
    'careInstructions': careInstructions,
    'confidence': confidence,
    'timestamp': timestamp.toIso8601String(),
    'isFavorite': isFavorite,
    'commonNames': commonNames,
    'family': family,
    'origin': origin,
  };

  factory PlantScanModel.fromEntity(PlantScan scan) => PlantScanModel(
    id: scan.id,
    imagePath: scan.imagePath,
    plantName: scan.plantName,
    scientificName: scan.scientificName,
    description: scan.description,
    careInstructions: scan.careInstructions,
    confidence: scan.confidence,
    timestamp: scan.timestamp,
    isFavorite: scan.isFavorite,
    commonNames: scan.commonNames,
    family: scan.family,
    origin: scan.origin,
  );
}
