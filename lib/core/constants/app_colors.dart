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

  // Impostor - Rojo muy suave y oscuro (menos reflectante)
  static const Color impostorBgDark = Color(0xFF2A1F1F); // Rojo más oscuro y menos reflectante
  static const Color impostorTextDark = Color(0xFFD4A5A5); // Rojo más oscuro y menos brillante
  static const Color impostorBorderDark = Color(0xFF4A2F2F); // Borde más oscuro

  // No-Impostor - Verde muy suave y oscuro (menos reflectante)
  static const Color playerBgDark = Color(0xFF1F2A23); // Verde más oscuro y menos reflectante
  static const Color playerTextDark = Color(0xFF8FB893); // Verde más oscuro y menos brillante
  static const Color playerBorderDark = Color(0xFF2F4A35); // Borde más oscuro

  // Impostor - Modo claro (menos reflectante)
  static const Color impostorBgLight = Color(0xFFF5E8E8); // Rosa más apagado
  static const Color impostorTextLight = Color(0xFF8B1A1A); // Rojo más oscuro y menos brillante
  static const Color impostorBorderLight = Color(0xFFE8C5C5); // Borde más apagado

  // No-Impostor - Modo claro (menos reflectante)
  static const Color playerBgLight = Color(0xFFE8F0EA); // Verde más apagado
  static const Color playerTextLight = Color(0xFF1F5A22); // Verde más oscuro y menos brillante
  static const Color playerBorderLight = Color(0xFFB8D5BC); // Borde más apagado

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
