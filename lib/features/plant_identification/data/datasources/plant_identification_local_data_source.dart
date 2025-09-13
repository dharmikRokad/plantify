import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/features/plant_identification/data/models/plant_scan_model.dart';

abstract class PlantIdentificationLocalDataSource {
  Future<List<PlantScanModel>> getPlantScans();
  Future<void> savePlantScan(PlantScanModel scan);
  Future<void> toggleFavorite(String scanId);
  Future<void> deletePlantScan(String scanId);
}

class PlantIdentificationLocalDataSourceImpl implements PlantIdentificationLocalDataSource {
  PlantIdentificationLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
  static const String cachedPlantScans = 'CACHED_PLANT_SCANS';

  @override
  Future<List<PlantScanModel>> getPlantScans() async {
    final jsonString = sharedPreferences.getString(cachedPlantScans);
    if (jsonString != null) {
      final jsonList = json.decode(jsonString) as List;
      return jsonList.map((json) => PlantScanModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> savePlantScan(PlantScanModel scan) async {
    final scans = await getPlantScans();
    scans.add(scan);
    final jsonString = json.encode(scans.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(cachedPlantScans, jsonString);
  }

  @override
  Future<void> toggleFavorite(String scanId) async {
    final scans = await getPlantScans();
    final scanIndex = scans.indexWhere((scan) => scan.id == scanId);
    if (scanIndex != -1) {
      final updatedScan = PlantScanModel.fromEntity(
        scans[scanIndex].copyWith(isFavorite: !scans[scanIndex].isFavorite)
      );
      scans[scanIndex] = updatedScan;
      final jsonString = json.encode(scans.map((e) => e.toJson()).toList());
      await sharedPreferences.setString(cachedPlantScans, jsonString);
    }
  }

  @override
  Future<void> deletePlantScan(String scanId) async {
    final scans = await getPlantScans();
    scans.removeWhere((scan) => scan.id == scanId);
    final jsonString = json.encode(scans.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(cachedPlantScans, jsonString);
  }
}