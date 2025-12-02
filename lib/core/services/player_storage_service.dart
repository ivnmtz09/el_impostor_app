import 'package:shared_preferences/shared_preferences.dart';

class PlayerStorageService {
  static const String _playerNamesKey = 'saved_player_names';

  /// Guarda la lista de nombres de jugadores
  static Future<void> savePlayerNames(List<String> playerNames) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_playerNamesKey, playerNames);
  }

  /// Carga la lista de nombres de jugadores guardados
  static Future<List<String>> loadPlayerNames() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNames = prefs.getStringList(_playerNamesKey);
    return savedNames ?? [];
  }

  /// Limpia los nombres guardados
  static Future<void> clearPlayerNames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_playerNamesKey);
  }
}

