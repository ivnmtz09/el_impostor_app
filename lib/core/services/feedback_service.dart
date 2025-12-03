import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class FeedbackService {
  static bool _soundEnabled = true;
  static bool _vibrationEnabled = true;
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final Map<String, AudioPlayer> _soundCache = {};

  static void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  static void setVibrationEnabled(bool enabled) {
    _vibrationEnabled = enabled;
  }

  static bool get isSoundEnabled => _soundEnabled;
  static bool get isVibrationEnabled => _vibrationEnabled;

  // Precarga de sonidos
  static Future<void> preloadSounds() async {
    final sounds = [
      'button_tap.mp3',
      'menu_select.mp3',
      'card_flip.mp3',
      'timer_tick.mp3',
      'timer_warning.mp3',
      'vote_submit.mp3',
      'win.mp3',
      'lose.mp3',
    ];

    for (final sound in sounds) {
      try {
        final player = AudioPlayer();
        // Configurar modo de baja latencia para efectos de sonido cortos
        await player.setAudioContext(
          AudioContext(
            iOS: AudioContextIOS(
              options: {
                AVAudioSessionOptions.duckOthers,
              },
              category: AVAudioSessionCategory.ambient,
            ),
            android: AudioContextAndroid(
              audioFocus: AndroidAudioFocus.none,
            ),
          ),
        );
        // Establecer volumen al máximo
        await player.setVolume(1.0);
        await player.setSource(AssetSource('sounds/$sound'));
        _soundCache[sound] = player;
      } catch (e) {
        print('Error precargando sonido $sound: $e');
      }
    }
  }

  // Reproducir sonido desde caché
  static Future<void> _playSound(String soundFile) async {
    if (!_soundEnabled) return;

    try {
      final player = _soundCache[soundFile];
      if (player != null) {
        try {
          // Detener la reproducción actual si está en curso
          await player.stop();
          // Ir al inicio del archivo
          await player.seek(Duration.zero);
          // Reproducir desde el principio
          await player.resume();
        } catch (e) {
          // Si hay error con seek/stop, intentar reproducir directamente
          print('Error en seek/stop para $soundFile, reintentando: $e');
          try {
            await player.play(AssetSource('sounds/$soundFile'));
          } catch (retryError) {
            print('Error al reproducir $soundFile en reintento: $retryError');
          }
        }
      } else {
        // Fallback si no está en caché
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource('sounds/$soundFile'));
      }
    } catch (e) {
      print('Error reproduciendo sonido $soundFile: $e');
    }
  }

  // Vibración ligera para tap
  static Future<void> lightVibration() async {
    if (!_vibrationEnabled) return;

    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 50);
    } else {
      HapticFeedback.lightImpact();
    }
  }

  // Vibración media para acciones importantes
  static Future<void> mediumVibration() async {
    if (!_vibrationEnabled) return;

    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 100);
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  // Vibración fuerte para eventos críticos
  static Future<void> heavyVibration() async {
    if (!_vibrationEnabled) return;

    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 200);
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  // Patrón de vibración para el impostor
  static Future<void> impostorRevealVibration() async {
    if (!_vibrationEnabled) return;

    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
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

    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 150);
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  // Patrón de vibración para alerta de tiempo
  static Future<void> timeWarningVibration() async {
    if (!_vibrationEnabled) return;

    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(
        pattern: [0, 100, 100, 100],
      );
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  static Future<void> victoryVibration() async {
    if (!_vibrationEnabled) return;
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      await Vibration.vibrate(pattern: [0, 100, 200, 100, 200, 400]);
    }
  }

  static Future<void> defeatVibration() async {
    if (!_vibrationEnabled) return;
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      await Vibration.vibrate(pattern: [0, 500, 100, 500]);
    }
  }

  // === SONIDOS ===

  static Future<void> playButtonTap() async {
    await _playSound('button_tap.mp3');
  }

  static Future<void> playMenuSelect() async {
    await _playSound('menu_select.mp3');
  }

  static Future<void> playCardFlip() async {
    await _playSound('card_flip.mp3');
  }

  static Future<void> playTimerTick() async {
    await _playSound('timer_tick.mp3');
  }

  static Future<void> playTimerWarning() async {
    await _playSound('timer_warning.mp3');
  }

  static Future<void> playVoteSubmit() async {
    await _playSound('vote_submit.mp3');
  }

  static Future<void> playWinSound() async {
    await _playSound('win.mp3');
  }

  static Future<void> playLoseSound() async {
    await _playSound('lose.mp3');
  }

  // Métodos legacy para compatibilidad
  static Future<void> playClickSound() async {
    await playButtonTap();
  }

  static Future<void> playSuccessSound() async {
    await playWinSound();
  }

  static Future<void> playErrorSound() async {
    await playLoseSound();
  }

  // Limpieza
  static Future<void> dispose() async {
    await _audioPlayer.dispose();
    for (final player in _soundCache.values) {
      await player.dispose();
    }
    _soundCache.clear();
  }
}
