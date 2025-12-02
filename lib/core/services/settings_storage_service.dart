import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorageService {
  static const String _soundEffectsKey = 'settings_sound_effects';
  static const String _vibrationKey = 'settings_vibration';
  static const String _impostorHintKey = 'settings_impostor_hint';
  static const String _debateTimeKey = 'settings_debate_time';
  static const String _impostorCountKey = 'settings_impostor_count';

  static const String _isDarkModeKey = 'settings_is_dark_mode';

  static Future<void> saveSettings({
    required bool soundEffects,
    required bool vibration,
    required bool impostorHint,
    required double debateTime,
    required double impostorCount,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEffectsKey, soundEffects);
    await prefs.setBool(_vibrationKey, vibration);
    await prefs.setBool(_impostorHintKey, impostorHint);
    await prefs.setDouble(_debateTimeKey, debateTime);
    await prefs.setDouble(_impostorCountKey, impostorCount);
  }

  static Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'soundEffects': prefs.getBool(_soundEffectsKey) ?? true,
      'vibration': prefs.getBool(_vibrationKey) ?? true,
      'impostorHint': prefs.getBool(_impostorHintKey) ?? true,
      'debateTime': prefs.getDouble(_debateTimeKey) ?? 3.0,
      'impostorCount': prefs.getDouble(_impostorCountKey),
    };
  }

  static Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDarkMode);
  }

  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? true;
  }
}
