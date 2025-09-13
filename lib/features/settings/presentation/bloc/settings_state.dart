part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
  
  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded(this.settings);

  final AppSettings settings;

  @override
  List<Object> get props => [settings];
}

class SettingsError extends SettingsState {
  const SettingsError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}