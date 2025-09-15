import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/splash/pages/splash_page.dart';
import 'package:myapp/theme.dart';
import 'package:myapp/injection_container.dart';
import 'package:myapp/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:myapp/features/plant_identification/presentation/pages/plant_result_page.dart';
import 'package:myapp/features/plant_identification/domain/entities/plant_scan.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ServiceLocator().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
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
            home: SplashPage(),
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
