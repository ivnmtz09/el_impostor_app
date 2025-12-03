// filepath: lib/core/services/audio_test_helper.dart

import 'package:el_impostor_app/core/services/feedback_service.dart';

/// Helper para probar y validar la funcionalidad de audio
class AudioTestHelper {
  /// Test 1: Reproducción múltiple del mismo sonido
  /// Debería escuchar 5 clicks sin necesidad de reiniciar
  static Future<void> testMultiplePlayback() async {
    print('🔊 Iniciando Test 1: Reproduccion Multiple');
    print('   Deberias escuchar 5 sonidos de click...\n');

    for (int i = 1; i <= 5; i++) {
      print('   Reproduccion $i...');
      await FeedbackService.playButtonTap();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    print('\n✅ Test 1 Completado\n');
  }

  /// Test 2: Diferentes sonidos en secuencia
  static Future<void> testSequence() async {
    print('🔊 Iniciando Test 2: Secuencia de Sonidos Diferentes');
    print('   Sonido 1: Click de boton');

    await FeedbackService.playButtonTap();
    await Future.delayed(const Duration(milliseconds: 800));

    print('   Sonido 2: Volteo de carta');
    await FeedbackService.playCardFlip();
    await Future.delayed(const Duration(milliseconds: 800));

    print('   Sonido 3: Tick del temporizador');
    await FeedbackService.playTimerTick();
    await Future.delayed(const Duration(milliseconds: 800));

    print('   Sonido 4: Alerta de tiempo');
    await FeedbackService.playTimerWarning();
    await Future.delayed(const Duration(milliseconds: 1000));

    print('   Sonido 5: Envio de voto');
    await FeedbackService.playVoteSubmit();
    await Future.delayed(const Duration(milliseconds: 800));

    print('   Sonido 6: Victoria');
    await FeedbackService.playWinSound();
    await Future.delayed(const Duration(milliseconds: 2000));

    print('   Sonido 9: Derrota');
    await FeedbackService.playLoseSound();
    await Future.delayed(const Duration(milliseconds: 2000));

    print('\n✅ Test 2 Completado\n');
  }

  /// Test 3: Estrés - Reproducción rápida
  static Future<void> testStress() async {
    print('🔊 Iniciando Test 3: Test de Estres (Reproduccion Rapida)');
    print('   Reproduciendo 10 clicks rapidamente...\n');

    for (int i = 1; i <= 10; i++) {
      print('   Reproduccion $i...');
      await FeedbackService.playButtonTap();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    print('\n✅ Test 3 Completado\n');
  }

  /// Test 4: Alterna activación/desactivación
  static Future<void> testToggle() async {
    print('🔊 Iniciando Test 4: Alternancia Activado/Desactivado');

    print('   Estado: ACTIVADO');
    FeedbackService.setSoundEnabled(true);
    print('   Reproduciendo sonido...');
    await FeedbackService.playButtonTap();
    await Future.delayed(const Duration(milliseconds: 500));

    print('\n   Estado: DESACTIVADO');
    FeedbackService.setSoundEnabled(false);
    print('   Intentando reproducir (no deberias escuchar nada)...');
    await FeedbackService.playButtonTap();
    await Future.delayed(const Duration(milliseconds: 500));

    print('\n   Estado: ACTIVADO (nuevamente)');
    FeedbackService.setSoundEnabled(true);
    print('   Reproduciendo sonido...');
    await FeedbackService.playButtonTap();
    await Future.delayed(const Duration(milliseconds: 500));

    print('\n✅ Test 4 Completado\n');
  }

  /// Ejecutar todos los tests
  static Future<void> runAllTests() async {
    print('\n' + '=' * 50);
    print('   SUITE COMPLETA DE TESTS DE AUDIO');
    print('=' * 50 + '\n');

    try {
      await testMultiplePlayback();
      await testSequence();
      await testStress();
      await testToggle();

      print('=' * 50);
      print('   ✅ TODOS LOS TESTS COMPLETADOS EXITOSAMENTE ✅');
      print('=' * 50 + '\n');
    } catch (e) {
      print('\n❌ ERROR DURANTE LOS TESTS:');
      print('   $e\n');
      rethrow;
    }
  }

  /// Test individual - para debugging
  static Future<void> testSingleSound(String soundName) async {
    print('🔊 Reproduciendo: $soundName');

    switch (soundName) {
      case 'button_tap':
        await FeedbackService.playButtonTap();
        break;
      case 'card_flip':
        await FeedbackService.playCardFlip();
        break;
      case 'timer_tick':
        await FeedbackService.playTimerTick();
        break;
      case 'timer_warning':
        await FeedbackService.playTimerWarning();
        break;
      case 'vote_submit':
        await FeedbackService.playVoteSubmit();
        break;
      case 'win':
        await FeedbackService.playWinSound();
        break;
      case 'lose':
        await FeedbackService.playLoseSound();
        break;
      default:
        print('❌ Sonido desconocido: $soundName');
    }
  }
}
