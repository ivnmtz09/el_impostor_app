import 'package:floor/floor.dart';
import '../../models/word_model.dart';

@dao
abstract class WordDao {
  @Query('SELECT * FROM Word')
  Future<List<Word>> getAllWords();

  @Query('SELECT * FROM Word WHERE categoria = :categoria AND activa = 1')
  Future<List<Word>> getWordsByCategory(String categoria);

  @Query('SELECT DISTINCT categoria FROM Word WHERE activa = 1')
  Future<List<String>> getAllCategories();

  @Query(
      'SELECT * FROM Word WHERE categoria = :categoria AND activa = 1 ORDER BY RANDOM() LIMIT 1')
  Future<Word?> getRandomWordFromCategory(String categoria);

  @Query(
      'SELECT * FROM Word WHERE categoria = :categoria AND activa = 1 ORDER BY RANDOM() LIMIT :limit')
  Future<List<Word>> getRandomWordsFromCategory(String categoria, int limit);

  @Query(
      'SELECT * FROM Word WHERE palabra LIKE :searchTerm OR categoria LIKE :searchTerm')
  Future<List<Word>> searchWords(String searchTerm);

  @insert
  Future<void> insertWord(Word word);

  @insert
  Future<void> insertWords(List<Word> words);

  @update
  Future<void> updateWord(Word word);

  @Query('UPDATE Word SET activa = 0 WHERE id = :id')
  Future<void> deactivateWord(int id);

  @delete
  Future<void> deleteWord(Word word);

  @Query('SELECT * FROM Word WHERE es_personalizada = 1 AND activa = 1')
  Future<List<Word>> getCustomWords();

  @Query(
      'SELECT COUNT(*) FROM Word WHERE categoria = :categoria AND activa = 1')
  Future<int?> countWordsByCategory(String categoria);

  @Query(
      'SELECT COUNT(*) FROM Word WHERE palabra = :palabra AND categoria = :categoria')
  Future<int?> wordExists(String palabra, String categoria);
}
