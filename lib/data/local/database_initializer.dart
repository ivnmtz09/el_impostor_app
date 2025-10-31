import '../../core/database/app_database.dart';
import '../../core/models/word_model.dart';
import 'categories_data.dart';

class DatabaseInitializer {
  static bool _isInitialized = false;

  static Future<void> initialize(AppDatabase database) async {
    if (_isInitialized) return;

    final words = await database.wordDao.getAllWords();

    if (words.isEmpty) {
      print('📦 Base de datos vacía. Cargando datos iniciales...');
      await _loadInitialData(database);
      print('✅ Datos iniciales cargados correctamente');
    } else {
      print('✓ Base de datos ya contiene ${words.length} palabras');
    }

    _isInitialized = true;
  }

  static Future<void> _loadInitialData(AppDatabase database) async {
    try {
      final wordsList = allWordsFromJson(allWordsData);
      await database.wordDao.insertWords(wordsList);
    } catch (e) {
      print('❌ Error al cargar datos iniciales: $e');
      rethrow;
    }
  }

  static Future<void> resetDatabase(AppDatabase database) async {
    final allWords = await database.wordDao.getAllWords();
    for (final word in allWords) {
      await database.wordDao.deleteWord(word);
    }
    _isInitialized = false;
    await initialize(database);
  }

  static Future<void> importWordsFromJson(
    AppDatabase database,
    String jsonData,
  ) async {
    try {
      final newWords = allWordsFromJson(jsonData);
      int imported = 0;
      int skipped = 0;

      for (final word in newWords) {
        final exists = await database.wordDao.wordExists(
          word.palabra,
          word.categoria,
        );

        if (exists == 0) {
          await database.wordDao.insertWord(word);
          imported++;
        } else {
          skipped++;
        }
      }

      print('📥 Importación completada: $imported nuevas, $skipped omitidas');
    } catch (e) {
      print('❌ Error al importar palabras: $e');
      rethrow;
    }
  }
}
