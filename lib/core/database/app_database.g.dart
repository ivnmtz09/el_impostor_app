// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WordDao? _wordDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Word` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `categoria` TEXT NOT NULL, `palabra` TEXT NOT NULL, `pista` TEXT NOT NULL, `es_personalizada` INTEGER NOT NULL, `activa` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WordDao get wordDao {
    return _wordDaoInstance ??= _$WordDao(database, changeListener);
  }
}

class _$WordDao extends WordDao {
  _$WordDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _wordInsertionAdapter = InsertionAdapter(
            database,
            'Word',
            (Word item) => <String, Object?>{
                  'id': item.id,
                  'categoria': item.categoria,
                  'palabra': item.palabra,
                  'pista': item.pista,
                  'es_personalizada': item.esPersonalizada ? 1 : 0,
                  'activa': item.activa ? 1 : 0
                }),
        _wordUpdateAdapter = UpdateAdapter(
            database,
            'Word',
            ['id'],
            (Word item) => <String, Object?>{
                  'id': item.id,
                  'categoria': item.categoria,
                  'palabra': item.palabra,
                  'pista': item.pista,
                  'es_personalizada': item.esPersonalizada ? 1 : 0,
                  'activa': item.activa ? 1 : 0
                }),
        _wordDeletionAdapter = DeletionAdapter(
            database,
            'Word',
            ['id'],
            (Word item) => <String, Object?>{
                  'id': item.id,
                  'categoria': item.categoria,
                  'palabra': item.palabra,
                  'pista': item.pista,
                  'es_personalizada': item.esPersonalizada ? 1 : 0,
                  'activa': item.activa ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Word> _wordInsertionAdapter;

  final UpdateAdapter<Word> _wordUpdateAdapter;

  final DeletionAdapter<Word> _wordDeletionAdapter;

  @override
  Future<List<Word>> getAllWords() async {
    return _queryAdapter.queryList('SELECT * FROM Word',
        mapper: (Map<String, Object?> row) => Word(
            id: row['id'] as int?,
            categoria: row['categoria'] as String,
            palabra: row['palabra'] as String,
            pista: row['pista'] as String,
            esPersonalizada: (row['es_personalizada'] as int) != 0,
            activa: (row['activa'] as int) != 0));
  }

  @override
  Future<List<Word>> getWordsByCategory(String categoria) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Word WHERE categoria = ?1 AND activa = 1',
        mapper: (Map<String, Object?> row) => Word(
            id: row['id'] as int?,
            categoria: row['categoria'] as String,
            palabra: row['palabra'] as String,
            pista: row['pista'] as String,
            esPersonalizada: (row['es_personalizada'] as int) != 0,
            activa: (row['activa'] as int) != 0),
        arguments: [categoria]);
  }

  @override
  Future<List<String>> getAllCategories() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT categoria FROM Word WHERE activa = 1',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<Word?> getRandomWordFromCategory(String categoria) async {
    return _queryAdapter.query(
        'SELECT * FROM Word WHERE categoria = ?1 AND activa = 1 ORDER BY RANDOM() LIMIT 1',
        mapper: (Map<String, Object?> row) => Word(id: row['id'] as int?, categoria: row['categoria'] as String, palabra: row['palabra'] as String, pista: row['pista'] as String, esPersonalizada: (row['es_personalizada'] as int) != 0, activa: (row['activa'] as int) != 0),
        arguments: [categoria]);
  }

  @override
  Future<List<Word>> getRandomWordsFromCategory(
    String categoria,
    int limit,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Word WHERE categoria = ?1 AND activa = 1 ORDER BY RANDOM() LIMIT ?2',
        mapper: (Map<String, Object?> row) => Word(id: row['id'] as int?, categoria: row['categoria'] as String, palabra: row['palabra'] as String, pista: row['pista'] as String, esPersonalizada: (row['es_personalizada'] as int) != 0, activa: (row['activa'] as int) != 0),
        arguments: [categoria, limit]);
  }

  @override
  Future<List<Word>> searchWords(String searchTerm) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Word WHERE palabra LIKE ?1 OR categoria LIKE ?1',
        mapper: (Map<String, Object?> row) => Word(
            id: row['id'] as int?,
            categoria: row['categoria'] as String,
            palabra: row['palabra'] as String,
            pista: row['pista'] as String,
            esPersonalizada: (row['es_personalizada'] as int) != 0,
            activa: (row['activa'] as int) != 0),
        arguments: [searchTerm]);
  }

  @override
  Future<void> deactivateWord(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Word SET activa = 0 WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<List<Word>> getCustomWords() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Word WHERE es_personalizada = 1 AND activa = 1',
        mapper: (Map<String, Object?> row) => Word(
            id: row['id'] as int?,
            categoria: row['categoria'] as String,
            palabra: row['palabra'] as String,
            pista: row['pista'] as String,
            esPersonalizada: (row['es_personalizada'] as int) != 0,
            activa: (row['activa'] as int) != 0));
  }

  @override
  Future<int?> countWordsByCategory(String categoria) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM Word WHERE categoria = ?1 AND activa = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [categoria]);
  }

  @override
  Future<int?> wordExists(
    String palabra,
    String categoria,
  ) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM Word WHERE palabra = ?1 AND categoria = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [palabra, categoria]);
  }

  @override
  Future<void> insertWord(Word word) async {
    await _wordInsertionAdapter.insert(word, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertWords(List<Word> words) async {
    await _wordInsertionAdapter.insertList(words, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWord(Word word) async {
    await _wordUpdateAdapter.update(word, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWord(Word word) async {
    await _wordDeletionAdapter.delete(word);
  }
}
