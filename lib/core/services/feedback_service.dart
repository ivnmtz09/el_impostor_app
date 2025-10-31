import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class FeedbackService {
  static bool _soundEnabled = true;
  static bool _vibrationEnabled = true;

  static void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  static void setVibrationEnabled(bool enabled) {
    _vibrationEnabled = enabled;
  }

  static bool get isSoundEnabled => _soundEnabled;
  static bool get isVibrationEnabled => _vibrationEnabled;

  // Vibración ligera para tap
  static Future<void> lightVibration() async {
    if (!_vibrationEnabled) return;

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    } else {
      HapticFeedback.lightImpact();
    }
  }

  // Vibración media para acciones importantes
  static Future<void> mediumVibration() async {
    if (!_vibrationEnabled) return;

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100);
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  // Vibración fuerte para eventos críticos
  static Future<void> heavyVibration() async {
    if (!_vibrationEnabled) return;

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 200);
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  // Patrón de vibración para el impostor
  static Future<void> impostorRevealVibration() async {
    if (!_vibrationEnabled) return;

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(
        pattern: [0, 100, 50, 100, 50, 200],
      );
    } else {
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      HapticFeedback.heavyImpact();
    }
  }

  // Patrón de vibración para no-impostor
  static Future<void> playerRevealVibration() async {
    if (!_vibrationEnabled) return;

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 150);
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  // Patrón de vibración para alerta de tiempo
  static Future<void> timeWarningVibration() async {
    if (!_vibrationEnabled) return;

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(
        pattern: [0, 100, 100, 100],
      );
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  // Sonido simple usando HapticFeedback como placeholder
  // En producción, usa AudioPlayers con archivos de audio reales
  static Future<void> playClickSound() async {
    if (!_soundEnabled) return;
    HapticFeedback.selectionClick();
  }

  static Future<void> playSuccessSound() async {
    if (!_soundEnabled) return;
    HapticFeedback.mediumImpact();
  }

  static Future<void> playErrorSound() async {
    if (!_soundEnabled) return;
    HapticFeedback.heavyImpact();
  }
}
