import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/data/repositories/word_repository.dart';
import 'package:el_impostor_app/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class ElImpostorApp extends StatelessWidget {
  final WordRepository wordRepository;

  const ElImpostorApp({super.key, required this.wordRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Impostor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.fondoPrincipal,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.fondoPrincipal,
          brightness: Brightness.dark,
          primary: AppColors.fondoPrincipal,
          secondary: AppColors.acentoCTA,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.fondoPrincipal,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: AppColors.textoPrincipal,
          ),
          titleTextStyle: TextStyle(
            color: AppColors.textoPrincipal,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textoPrincipal, fontSize: 16),
          headlineLarge: TextStyle(
            color: AppColors.textoPrincipal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: SplashScreen(wordRepository: wordRepository),
    );
  }
}
