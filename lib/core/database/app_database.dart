import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../models/word_model.dart';
import 'dao/word_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Word])
abstract class AppDatabase extends FloorDatabase {
  WordDao get wordDao;

  static Future<AppDatabase> buildDatabase() async {
    return await $FloorAppDatabase
        .databaseBuilder('impostor_database.db')
        .build();
  }
}
