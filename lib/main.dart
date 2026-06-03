import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'providers/theme_provider.dart';
import 'database/hive_service.dart';
import 'providers/study_provider.dart';
import 'screens/splash.d

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => StudyProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      themeMode:
      themeProvider.isDark
          ? ThemeMode.dark
          : ThemeMode.light,

      home: const SplashScreen(),
    );
  }
}