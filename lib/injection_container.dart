import 'package:myapp/features/plant_identification/data/datasources/plant_identification_remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/features/plant_identification/data/datasources/plant_identification_local_data_source.dart';
import 'package:myapp/features/plant_identification/data/repositories/plant_identification_repository_impl.dart';
import 'package:myapp/features/plant_identification/domain/repositories/plant_identification_repository.dart';
import 'package:myapp/features/plant_identification/domain/usecases/identify_plant.dart';
import 'package:myapp/features/plant_identification/presentation/bloc/plant_identification_bloc.dart';
import 'package:myapp/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:myapp/features/settings/domain/repositories/settings_repository.dart';
import 'package:myapp/features/settings/presentation/bloc/settings_bloc.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late SharedPreferences _sharedPreferences;

  // Repositories
  late PlantIdentificationRepository _plantIdentificationRepository;
  late SettingsRepository _settingsRepository;

  // Use Cases
  late IdentifyPlant _identifyPlant;

  // BLoCs
  PlantIdentificationBloc? _plantIdentificationBloc;
  SettingsBloc? _settingsBloc;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _setupRepositories();
    _setupUseCases();
  }

  void _setupRepositories() {
    // Plant Identification
    final plantLocalDataSource = PlantIdentificationLocalDataSourceImpl(
      sharedPreferences: _sharedPreferences,
    );

    final plantRemoteDataSource = PlantIdentificationRemoteDataSourceImpl();

    _plantIdentificationRepository = PlantIdentificationRepositoryImpl(
      localDataSource: plantLocalDataSource,
      remoteDataSource: plantRemoteDataSource,
    );

    // Settings
    _settingsRepository = SettingsRepositoryImpl(
      sharedPreferences: _sharedPreferences,
    );
  }

  void _setupUseCases() {
    _identifyPlant = IdentifyPlant(_plantIdentificationRepository);
  }

  // Getters for BLoCs
  PlantIdentificationBloc get plantIdentificationBloc =>
      _plantIdentificationBloc ??= PlantIdentificationBloc(
        identifyPlant: _identifyPlant,
        repository: _plantIdentificationRepository,
      );

  SettingsBloc get settingsBloc =>
      _settingsBloc ??= SettingsBloc(repository: _settingsRepository);

  void dispose() {
    _plantIdentificationBloc?.close();
    _settingsBloc?.close();
    _plantIdentificationBloc = null;
    _settingsBloc = null;
  }
}
