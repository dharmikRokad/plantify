import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:myapp/features/plant_identification/data/models/plant_scan_model.dart';

abstract class PlantIdentificationRemoteDataSource {
  Future<PlantScanModel> identifyPlant(Uint8List imageBytes);
}

class PlantIdentificationRemoteDataSourceImpl implements PlantIdentificationRemoteDataSource {
  @override
  Future<PlantScanModel> identifyPlant(Uint8List imageBytes) async {
    final model = FirebaseAI.vertexAI().generativeModel(model: 'gemini-1.5-flash');
      final content = [Content.multi([
        TextPart('Identify the plant in the image.'),
        InlineDataPart('image/jpeg', imageBytes),
        TextPart(
          '''
The response should be formatted as the following example JSON:
{
  'plantName': 'Snake Plant',
  'scientificName': 'Sansevieria trifasciata',
  'description': 'A hardy succulent with tall, sword-like leaves featuring green and yellow striping. Known for its air-purifying qualities and extreme low-maintenance care.',
  'careInstructions': 'Water sparingly, every 2-3 weeks. Can tolerate low light to bright light. Avoid overwatering. Very drought tolerant. Temperature: 60-85°F.',
  'family': 'Asparagaceae',
  'origin': 'West Africa',
  'commonNames': ['Mother-in-law\'s Tongue', 'Viper\'s Bowstring Hemp', 'Saint George\'s Sword'],
}
          '''
        ),
      ])];
      final response = await model.generateContent(content);

        // This is a simplified version. In a real app, you'd parse the response
        // and create a proper PlantScan object.
        final scan = PlantScanModel.fromJson(
          jsonDecode(response.text
                ?.replaceAll(RegExp(r'```json', caseSensitive: false), '')
                .replaceAll('```', '')
                .trim() ??
            '{}',)
        );
        return scan;
  }
}
