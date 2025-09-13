import 'package:dartz/dartz.dart';
import 'package:myapp/core/errors/failures.dart';
import 'package:myapp/features/settings/domain/entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppSettings>> getSettings();
  Future<Either<Failure, void>> saveSettings(AppSettings settings);
}