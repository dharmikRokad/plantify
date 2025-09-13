import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/core/errors/failures.dart';
import 'package:myapp/features/settings/domain/entities/app_settings.dart';
import 'package:myapp/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
  static const String themeModeKey = 'THEME_MODE';

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final themeModeIndex = sharedPreferences.getInt(themeModeKey) ?? 0;
      final themeMode = ThemeMode.values[themeModeIndex];
      
      return Right(AppSettings(themeMode: themeMode));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(AppSettings settings) async {
    try {
      await sharedPreferences.setInt(themeModeKey, settings.themeMode.index);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}