import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // Tema Oscuro
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.fondoPrincipalDark,
      fontFamily: 'Montserrat',
      
      // Esquema de colores
      colorScheme: ColorScheme.dark(
        primary: AppColors.acentoCTADark,
        secondary: AppColors.acentoSecundarioDark,
        surface: AppColors.fondoSecundarioDark,
        error: Colors.red[400]!,
        onPrimary: AppColors.textoBotonDark,
        onSecondary: AppColors.textoPrincipalDark,
        onSurface: AppColors.textoPrincipalDark,
      ),

      // Tipografía
      textTheme: ThemeData.dark().textTheme.copyWith(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textoPrincipalDark,
        ),
        displayMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textoPrincipalDark,
        ),
        displaySmall: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textoPrincipalDark,
        ),
        headlineMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textoPrincipalDark,
        ),
        titleLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textoPrincipalDark,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          color: AppColors.textoPrincipalDark,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: AppColors.textoSecundarioDark,
        ),
      ).apply(fontFamily: 'Montserrat'),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.fondoPrincipalDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textoPrincipalDark,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(color: AppColors.textoPrincipalDark),
      ),

      // Botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.acentoCTADark,
          foregroundColor: AppColors.textoBotonDark,
          elevation: 8,
          shadowColor: AppColors.acentoCTADark.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.fondoSecundarioDark,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fondoSecundarioDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.acentoCTADark, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textoSecundarioDark),
        hintStyle: TextStyle(color: AppColors.textoSecundarioDark.withOpacity(0.6)),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: Colors.white12,
        thickness: 1,
      ),
    );
  }

  // Tema Claro
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.fondoPrincipalLight,
      fontFamily: 'Montserrat',
      
      // Esquema de colores
      colorScheme: ColorScheme.light(
        primary: AppColors.acentoCTALight,
        secondary: AppColors.acentoSecundarioLight,
        surface: AppColors.fondoSecundarioLight,
        error: Colors.red[700]!,
        onPrimary: AppColors.textoBotonLight,
        onSecondary: AppColors.textoPrincipalLight,
        onSurface: AppColors.textoPrincipalLight,
      ),

      // Tipografía
      textTheme: ThemeData.light().textTheme.copyWith(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textoPrincipalLight,
        ),
        displayMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textoPrincipalLight,
        ),
        displaySmall: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textoPrincipalLight,
        ),
        headlineMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textoPrincipalLight,
        ),
        titleLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textoPrincipalLight,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          color: AppColors.textoPrincipalLight,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: AppColors.textoSecundarioLight,
        ),
      ).apply(fontFamily: 'Montserrat'),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.fondoPrincipalLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textoPrincipalLight,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(color: AppColors.textoPrincipalLight),
      ),

      // Botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.acentoCTALight,
          foregroundColor: AppColors.textoBotonLight,
          elevation: 8,
          shadowColor: AppColors.acentoCTALight.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.fondoSecundarioLight,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fondoSecundarioLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.acentoCTALight, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textoSecundarioLight),
        hintStyle: TextStyle(color: AppColors.textoSecundarioLight.withOpacity(0.6)),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: Colors.black12,
        thickness: 1,
      ),
    );
  }
}
