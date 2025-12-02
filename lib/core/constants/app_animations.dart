import 'package:flutter/animation.dart';

/// Configuraciones centralizadas de animaciones para la aplicación
class AppAnimations {
  // Duraciones estándar
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Curvas de animación
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeOutCubic;
  static const Curve sharpCurve = Curves.easeInOutCubic;
  static const Curve emphasizedCurve = Curves.easeInOutQuart;

  // Configuraciones específicas
  static const Duration buttonPress = Duration(milliseconds: 100);
  static const Duration cardFlip = Duration(milliseconds: 600);
  static const Duration pageTransition = Duration(milliseconds: 400);
  static const Duration shimmer = Duration(milliseconds: 1500);
  static const Duration pulse = Duration(milliseconds: 1000);
  static const Duration confetti = Duration(milliseconds: 3000);

  // Valores de escala
  static const double buttonPressScale = 0.95;
  static const double hoverScale = 1.05;
  static const double popScale = 1.2;
}
