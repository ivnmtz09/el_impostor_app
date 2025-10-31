import '../../core/database/app_database.dart';
import '../../core/models/word_model.dart';

class WordRepository {
  final AppDatabase _database;

  WordRepository(this._database);

  Future<List<String>> getCategories() async {
    return await _database.wordDao.getAllCategories();
  }

  Future<List<Word>> getWordsByCategory(String categoria) async {
    return await _database.wordDao.getWordsByCategory(categoria);
  }

  Future<Word?> selectSecretWord(String categoria) async {
    return await _database.wordDao.getRandomWordFromCategory(categoria);
  }

  Future<List<Word>> getRandomWords(String categoria, int count) async {
    return await _database.wordDao.getRandomWordsFromCategory(categoria, count);
  }

  Future<void> addCustomWord({
    required String categoria,
    required String palabra,
    required String pista,
  }) async {
    final word = Word(
      categoria: categoria,
      palabra: palabra,
      pista: pista,
      esPersonalizada: true,
    );
    await _database.wordDao.insertWord(word);
  }

  Future<List<Word>> getCustomWords() async {
    return await _database.wordDao.getCustomWords();
  }

  Future<void> updateWord(Word word) async {
    await _database.wordDao.updateWord(word);
  }

  Future<void> deactivateWord(int wordId) async {
    await _database.wordDao.deactivateWord(wordId);
  }

  Future<void> deleteWord(Word word) async {
    await _database.wordDao.deleteWord(word);
  }

  Future<List<Word>> searchWords(String query) async {
    return await _database.wordDao.searchWords('%$query%');
  }

  Future<int> countWords(String categoria) async {
    final count = await _database.wordDao.countWordsByCategory(categoria);
    return count ?? 0;
  }

  Future<bool> wordExists(String palabra, String categoria) async {
    final count = await _database.wordDao.wordExists(palabra, categoria);
    return (count ?? 0) > 0;
  }
}
