import 'dart:math';
import 'package:myapp/features/plant_identification/data/models/plant_scan_model.dart';

abstract class PlantIdentificationRemoteDataSource {
  Future<PlantScanModel> identifyPlant(String imagePath);
}

class PlantIdentificationRemoteDataSourceImpl implements PlantIdentificationRemoteDataSource {
  // Mock AI service simulating Google Gemini
  final List<Map<String, dynamic>> _samplePlants = [
    {
      'plantName': 'Peace Lily',
      'scientificName': 'Spathiphyllum wallisii',
      'description': 'An elegant flowering houseplant known for its glossy dark green leaves and distinctive white blooms. Peace lilies are excellent air purifiers and thrive in low to medium light conditions.',
      'careInstructions': 'Water when top inch of soil feels dry. Prefers bright, indirect light. Mist leaves regularly. Keep away from direct sunlight. Temperature: 65-80°F.',
      'family': 'Araceae',
      'origin': 'Tropical Americas and southeastern Asia',
      'commonNames': ['Peace Lily', 'White Flag', 'Spathe Flower'],
    },
    {
      'plantName': 'Monstera Deliciosa',
      'scientificName': 'Monstera deliciosa',
      'description': 'A striking tropical plant famous for its large, glossy leaves with natural holes (fenestrations). This climbing vine can grow quite large and makes a stunning statement piece.',
      'careInstructions': 'Water when top 2 inches of soil are dry. Bright, indirect light. Provide support for climbing. High humidity preferred. Temperature: 65-85°F.',
      'family': 'Araceae',
      'origin': 'Central America',
      'commonNames': ['Swiss Cheese Plant', 'Split-leaf Philodendron', 'Ceriman'],
    },
    {
      'plantName': 'Snake Plant',
      'scientificName': 'Sansevieria trifasciata',
      'description': 'A hardy succulent with tall, sword-like leaves featuring green and yellow striping. Known for its air-purifying qualities and extreme low-maintenance care.',
      'careInstructions': 'Water sparingly, every 2-3 weeks. Can tolerate low light to bright light. Avoid overwatering. Very drought tolerant. Temperature: 60-85°F.',
      'family': 'Asparagaceae',
      'origin': 'West Africa',
      'commonNames': ['Mother-in-law\'s Tongue', 'Viper\'s Bowstring Hemp', 'Saint George\'s Sword'],
    },
    {
      'plantName': 'Fiddle Leaf Fig',
      'scientificName': 'Ficus lyrata',
      'description': 'A popular houseplant with large, violin-shaped leaves. Native to western Africa, it can grow into a stunning indoor tree with proper care.',
      'careInstructions': 'Water when top inch of soil is dry. Bright, indirect light. Rotate weekly for even growth. Wipe leaves clean regularly. Temperature: 65-75°F.',
      'family': 'Moraceae',
      'origin': 'Western Africa',
      'commonNames': ['Fiddle Leaf Fig', 'Banjo Fig'],
    },
    {
      'plantName': 'Rubber Plant',
      'scientificName': 'Ficus elastica',
      'description': 'An attractive plant with thick, glossy, dark green leaves. It\'s known for its air-purifying abilities and can grow into a substantial indoor tree.',
      'careInstructions': 'Water when top 2 inches of soil are dry. Bright, indirect light. Wipe leaves regularly. Prefers warm, humid conditions. Temperature: 60-80°F.',
      'family': 'Moraceae',
      'origin': 'Eastern parts of South Asia and Southeast Asia',
      'commonNames': ['Rubber Tree', 'India Rubber Bush', 'Rubber Fig'],
    },
  ];

  @override
  Future<PlantScanModel> identifyPlant(String imagePath) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Randomly select a plant from sample data
    final random = Random();
    final selectedPlant = _samplePlants[random.nextInt(_samplePlants.length)];
    
    // Generate random confidence score
    final confidence = 0.7 + (random.nextDouble() * 0.25); // 70-95%
    
    return PlantScanModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: imagePath,
      plantName: selectedPlant['plantName'],
      scientificName: selectedPlant['scientificName'],
      description: selectedPlant['description'],
      careInstructions: selectedPlant['careInstructions'],
      confidence: confidence,
      timestamp: DateTime.now(),
      family: selectedPlant['family'],
      origin: selectedPlant['origin'],
      commonNames: List<String>.from(selectedPlant['commonNames']),
    );
  }
}