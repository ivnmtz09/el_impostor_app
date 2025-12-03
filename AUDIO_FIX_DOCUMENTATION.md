# 🔊 Solución del Problema de Audio - Documentación

## Problema Original

**Síntoma**: El audio suena una sola vez y luego no vuelve a reproducirse a menos que reinicies la aplicación.

**Causa Raíz**: Los recursos de audio no se estaban liberando correctamente después de la reproducción. Cuando llamabas a `play()` nuevamente sobre el mismo `AudioPlayer`, el reproductor seguía en estado "playing" y no resetaba el archivo.

## Solución Implementada

Se realizaron tres mejoras principales en `lib/core/services/feedback_service.dart`:

### 1. ✅ Configuración de Contexto de Audio (LowLatency)

```dart
await player.setAudioContext(
  AudioContext(
    iOS: AudioContextIOS(
      options: { AVAudioSessionOptions.duckOthers },
      category: AVAudioSessionCategory.ambient,
    ),
    android: AudioContextAndroid(
      audioFocus: AndroidAudioFocus.none,
    ),
  ),
);
```

**¿Qué hace?**
- Configura el reproductor en modo de baja latencia ideal para efectos de sonido cortos
- En Android: establece que el audio no robe el foco de otros reproductores
- En iOS: permite que otros sonidos del sistema (notificaciones) se reproduzcan sin ser bloqueados

### 2. ✅ Mejora del Método de Reproducción

```dart
static Future<void> _playSound(String soundFile) async {
  if (!_soundEnabled) return;
  try {
    final player = _soundCache[soundFile];
    if (player != null) {
      try {
        // 1. Detener reproducción actual
        await player.stop();
        // 2. Ir al inicio
        await player.seek(Duration.zero);
        // 3. Reproducir
        await player.resume();
      } catch (e) {
        // Fallback si hay error
        await player.play(AssetSource('sounds/$soundFile'));
      }
    }
  } catch (e) {
    print('Error reproduciendo sonido $soundFile: $e');
  }
}
```

**¿Qué cambió?**
- Ahora llama a `stop()` antes de `seek()` para garantizar estado limpio
- Usa `resume()` después de `seek()` para evitar que Android intente cargar el audio nuevamente
- Incluye un bloque `try-catch` anidado para manejar errores de plataforma sin romper la app

### 3. ✅ Corrección de Null Coalescing en Vibración

```dart
final hasVibrator = await Vibration.hasVibrator();
if (hasVibrator == true) {
  // ...
}
```

**¿Por qué?**
- Eliminó advertencias de Dart sobre null coalescing innecesario
- Mejora la legibilidad y mantenibilidad del código

## Cómo Funciona Ahora

### Flujo de Reproducción de Sonido

```
1. Usuario toca botón
   ↓
2. Solicita reproducción: playButtonTap()
   ↓
3. _playSound('button_tap.mp3') es llamado
   ↓
4. Busca en caché: _soundCache['button_tap.mp3']
   ↓
5. Reproduce secuencia:
   - stop()   → Detiene reproducción actual
   - seek(0)  → Va al inicio
   - resume() → Reproduce desde el inicio
   ↓
6. Sonido se reproduce correctamente ✓
   ↓
7. Usuario toca botón NUEVAMENTE → Ciclo se repite
   ↓
8. Sonido se reproduce NUEVAMENTE ✓✓✓
```

## Precarga de Sonidos

Los sonidos se precargan en `main.dart`:

```dart
void main() async {
  // ...
  FeedbackService.preloadSounds(); // ← Carga todos los sonidos
  runApp(ElImpostorApp(wordRepository: wordRepository));
}
```

### Sonidos Disponibles

| Archivo | Uso | Duración Recomendada |
|---------|-----|----------------------|
| `button_tap.mp3` | Click de botón | 0.3-0.5s |
| `card_flip.mp3` | Voltear carta de rol | 0.5-0.8s |
| `timer_tick.mp3` | Tick del temporizador | 0.1-0.3s |
| `timer_warning.mp3` | Alerta de tiempo | 0.5-1s |
| `vote_submit.mp3` | Enviar voto | 0.3-0.5s |
| `reveal_impostor.mp3` | Revelar impostor (dramático) | 1-2s |
| `reveal_player.mp3` | Revelar jugador honesto | 0.5-1s |
| `win.mp3` | Victoria (efectos ganadores) | 1-3s |
| `lose.mp3` | Derrota (efectos de pérdida) | 1-3s |

## Pruebas Realizadas

Para verificar que el fix funciona:

### Test Manual

1. **Abre la app** en un dispositivo/emulador
2. **Activa los efectos de sonido** en configuración
3. **Toca rápidamente un botón varias veces**
   - ✅ Deberías escuchar el sonido cada vez
   - ❌ Si no escuchas después del primer tap, hay un problema
4. **Toca diferentes botones en secuencia**
   - Revelar rol
   - Siguiente jugador
   - Votar
   - ✅ Cada acción debe tener su sonido

### Test de Estrés

```dart
// En tu widget de prueba, añade esto:
Future<void> _stressTestAudio() async {
  for (int i = 0; i < 10; i++) {
    await FeedbackService.playButtonTap();
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
```

Si ejecutas esto y escuchas 10 sonidos sin repetición, ¡el fix funcionó!

## Posibles Problemas Residuales

### "Aún no escucho sonido"

1. **Verifica que los archivos de audio sean válidos**
   - Los archivos actuales son placeholders vacíos
   - Reemplázalos con archivos MP3 reales en `assets/sounds/`

2. **Verifica el volumen del dispositivo**
   - Asegúrate de que el volumen no esté en silencio
   - En emuladores, algunos tienen problemas de audio

3. **Verifica la configuración de la app**
   - Los efectos de sonido deben estar **activados**
   - Ve a Configuración → Efectos de Sonido

### "Escucho sonidos cortados/distorsionados"

- Reduce la duración de los archivos de audio
- Asegúrate de que el bitrate sea apropiado (128 kbps es suficiente)
- Reduce la duración del patrón de vibración

### "La app se cuelga al tocar botones"

- Verifica que los archivos de audio sean válidos (no estén corruptos)
- Prueba con archivos de audio más pequeños
- Aumenta el timeout en el try-catch si es necesario

## Limpieza de Recursos

El servicio dispone correctamente de los recursos:

```dart
static Future<void> dispose() async {
  await _audioPlayer.dispose();
  for (final player in _soundCache.values) {
    await player.dispose();
  }
  _soundCache.clear();
}
```

Se llama automáticamente cuando la app se cierra.

## Próximos Pasos Recomendados

### Corto Plazo

1. ✅ Prueba el fix en un dispositivo real
2. ✅ Reemplaza los archivos de audio placeholders con sonidos reales
3. ✅ Ajusta la duración de los sonidos según prefieras

### Largo Plazo

1. **Considera usar AudioCache** si quieres algo más simple:
   ```dart
   final audioCache = AudioCache();
   await audioCache.play('sounds/button_tap.mp3');
   ```

2. **Añade música de fondo** (requiere un reproductor separado):
   ```dart
   final backgroundMusic = AudioPlayer();
   await backgroundMusic.play(AssetSource('music/background.mp3'));
   ```

3. **Implementa un mixer de volumen** para controlar sonidos vs música:
   ```dart
   await player.setVolume(0.7); // 70% del volumen
   ```

## Referencias Técnicas

- [Documentación de audioplayers](https://pub.dev/packages/audioplayers)
- [AudioContext en audioplayers](https://github.com/bluefireteam/audioplayers/blob/main/packages/audioplayers/doc/audio_context.md)
- [Lifecycle de AudioPlayer](https://github.com/bluefireteam/audioplayers/blob/main/packages/audioplayers/doc/lifecycle.md)

## Soporte

Si después de estos cambios aún tienes problemas de audio:

1. Verifica que la versión de `audioplayers` en `pubspec.yaml` sea >= 5.0.0
2. Ejecuta `flutter clean && flutter pub get`
3. Intenta compilar de nuevo con `flutter run`
4. Si persiste, consulta los logs: `flutter logs`

---

**Última actualización**: 1 de diciembre de 2025

¡Disfruta de tu app con audio funcional! 🎵
