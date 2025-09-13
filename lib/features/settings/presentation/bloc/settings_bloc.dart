import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/features/settings/domain/entities/app_settings.dart';
import 'package:myapp/features/settings/domain/repositories/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required this.repository}) : super(SettingsInitial()) {
    on<SettingsLoadRequested>(_onLoadRequested);
    on<ThemeChanged>(_onThemeChanged);
  }

  final SettingsRepository repository;

  Future<void> _onLoadRequested(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await repository.getSettings();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final newSettings = currentSettings.copyWith(themeMode: event.themeMode);
      
      final result = await repository.saveSettings(newSettings);
      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (_) => emit(SettingsLoaded(newSettings)),
      );
    }
  }
}