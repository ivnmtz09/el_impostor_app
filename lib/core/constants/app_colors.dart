import 'package:flutter/material.dart';

class AppColors {
  // --- TEMA OSCURO (Morado/Amarillo) ---

  // Morados oscuros para fondos
  static const Color fondoPrincipalDark =
      Color(0xFF1A1625); // Morado muy oscuro
  static const Color fondoSecundarioDark = Color(0xFF2D2438); // Morado oscuro
  static const Color fondoDrawerDark = Color(0xFF251E31); // Morado medio oscuro

  // Amarillo/Dorado vibrante para acentos
  static const Color acentoCTADark = Color(0xFFFFC107); // Amarillo dorado
  static const Color acentoSecundarioDark = Color(0xFFB388FF); // Morado claro

  // Textos
  static const Color textoPrincipalDark = Color(0xFFFFFFFF);
  static const Color textoBotonDark = Color(0xFF1A1625);
  static const Color textoSecundarioDark = Color(0xFFB0A8BA);

  // --- TEMA CLARO (Morado/Amarillo) ---

  // Colores claros para fondos
  static const Color fondoPrincipalLight =
      Color(0xFFF5F3F7); // Gris muy claro con tinte morado
  static const Color fondoSecundarioLight = Color(0xFFFFFFFF); // Blanco
  static const Color fondoDrawerLight = Color(0xFFECE8F0); // Gris claro morado

  // Morado vibrante para acentos
  static const Color acentoCTALight = Color(0xFF7E57C2); // Morado
  static const Color acentoSecundarioLight = Color(0xFFFFB300); // Amarillo

  // Textos
  static const Color textoPrincipalLight = Color(0xFF2D2438);
  static const Color textoBotonLight = Color(0xFFFFFFFF);
  static const Color textoSecundarioLight = Color(0xFF6B5B7B);

  // --- COLORES PARA ROLES (DISCRETOS) ---

  // Impostor - Rojo muy suave y oscuro
  static const Color impostorBgDark = Color(0xFF3A2828); // Rojo oscuro discreto
  static const Color impostorTextDark = Color(0xFFFFABAB); // Rojo rosado suave
  static const Color impostorBorderDark = Color(0xFF5A3838);

  // No-Impostor - Verde muy suave y oscuro
  static const Color playerBgDark = Color(0xFF283A2E); // Verde oscuro discreto
  static const Color playerTextDark = Color(0xFFA5D6A7); // Verde claro suave
  static const Color playerBorderDark = Color(0xFF385A42);

  // Impostor - Modo claro
  static const Color impostorBgLight = Color(0xFFFFF3F3); // Rosa muy claro
  static const Color impostorTextLight = Color(0xFFC62828); // Rojo oscuro
  static const Color impostorBorderLight = Color(0xFFFFCDD2);

  // No-Impostor - Modo claro
  static const Color playerBgLight = Color(0xFFF1F8F4); // Verde muy claro
  static const Color playerTextLight = Color(0xFF2E7D32); // Verde oscuro
  static const Color playerBorderLight = Color(0xFFC8E6C9);

  // --- GETTERS DINÁMICOS (según tema) ---

  static bool _isDarkMode = true;

  static void setDarkMode(bool isDark) {
    _isDarkMode = isDark;
  }

  static bool get isDarkMode => _isDarkMode;

  // Fondos
  static Color get fondoPrincipal =>
      _isDarkMode ? fondoPrincipalDark : fondoPrincipalLight;

  static Color get fondoSecundario =>
      _isDarkMode ? fondoSecundarioDark : fondoSecundarioLight;

  static Color get fondoDrawer =>
      _isDarkMode ? fondoDrawerDark : fondoDrawerLight;

  // Acentos
  static Color get acentoCTA => _isDarkMode ? acentoCTADark : acentoCTALight;

  static Color get acentoSecundario =>
      _isDarkMode ? acentoSecundarioDark : acentoSecundarioLight;

  // Textos
  static Color get textoPrincipal =>
      _isDarkMode ? textoPrincipalDark : textoPrincipalLight;

  static Color get textoBoton => _isDarkMode ? textoBotonDark : textoBotonLight;

  static Color get textoSecundario =>
      _isDarkMode ? textoSecundarioDark : textoSecundarioLight;

  // Roles
  static Color get impostorBg => _isDarkMode ? impostorBgDark : impostorBgLight;

  static Color get impostorText =>
      _isDarkMode ? impostorTextDark : impostorTextLight;

  static Color get impostorBorder =>
      _isDarkMode ? impostorBorderDark : impostorBorderLight;

  static Color get playerBg => _isDarkMode ? playerBgDark : playerBgLight;

  static Color get playerText => _isDarkMode ? playerTextDark : playerTextLight;

  static Color get playerBorder =>
      _isDarkMode ? playerBorderDark : playerBorderLight;
}
