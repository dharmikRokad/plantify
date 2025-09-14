import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/value_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/theme.dart';
import 'package:myapp/injection_container.dart';
import 'package:myapp/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:myapp/features/home/presentation/pages/home_page.dart';
import 'package:myapp/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:myapp/features/plant_identification/presentation/pages/plant_result_page.dart';
import 'package:myapp/features/plant_identification/domain/entities/plant_scan.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ServiceLocator().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueCubit<bool> _showOnboarding = ValueCubit(true);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('onboarding_completed') ?? false;
    
    if (mounted) {
        _showOnboarding.value = !hasCompletedOnboarding;
        _isLoading = false;
    }
  }

  void _onOnboardingComplete() {
    if (mounted) {
        _showOnboarding.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ServiceLocator().plantIdentificationBloc),
        BlocProvider(create: (_) => ServiceLocator().settingsBloc),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          final themeMode = settingsState is SettingsLoaded
              ? settingsState.settings.themeMode
              : ThemeMode.system;

          return MaterialApp(
            title: 'Evergreen - Plant Identifier',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            home: _showOnboarding.value
                ? OnboardingPage(onComplete: _onOnboardingComplete) 
                : const HomePage(),
            onGenerateRoute: (settings) {
              if (settings.name == '/result') {
                final scan = settings.arguments as PlantScan;
                return MaterialPageRoute(
                  builder: (_) => PlantResultPage(scan: scan),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
