import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.language = 'en',
  });

  final ThemeMode themeMode;
  final String language;

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? language,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    language: language ?? this.language,
  );

  @override
  List<Object> get props => [themeMode, language];
}