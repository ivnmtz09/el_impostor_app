import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class ElImpostorApp extends StatelessWidget {
  const ElImpostorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Impostor',
      debugShowCheckedModeBanner: false, // Quita la cinta de "Debug"
      // --- TEMA GLOBAL DE LA APP ---
      theme: ThemeData(
        useMaterial3: true,
        // Color de fondo para todas las pantallas (Scaffolds)
        scaffoldBackgroundColor: AppColors.fondoPrincipal,

        // Paleta de colores principal
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.fondoPrincipal,
          brightness:
              Brightness.dark, // Importante para que los textos sean claros
          primary: AppColors.fondoPrincipal,
          secondary: AppColors.acentoCTA,
        ),

        // Tema de la AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor:
              AppColors.fondoPrincipal, // Fondo de AppBar explícito
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: AppColors.textoPrincipal,
          ), // Icono de menú blanco
          titleTextStyle: TextStyle(
            color: AppColors.textoPrincipal,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Estilo de texto por defecto
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textoPrincipal, fontSize: 16),
          headlineLarge: TextStyle(
            color: AppColors.textoPrincipal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // --- FIN DEL TEMA ---

      // La primera pantalla que se mostrará
      home: const SplashScreen(),
    );
  }
}
