import 'package:el_impostor_app/core/database/app_database.dart';
import 'package:el_impostor_app/data/local/database_initializer.dart';
import 'package:el_impostor_app/data/repositories/word_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:el_impostor_app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Forzar la app a modo vertical
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicializar base de datos
  print('🔄 Inicializando base de datos...');
  final database = await AppDatabase.buildDatabase();

  // Cargar datos iniciales si es necesario
  await DatabaseInitializer.initialize(database);

  // Crear repositorio
  final wordRepository = WordRepository(database);
  print('✅ Base de datos lista');

  runApp(ElImpostorApp(wordRepository: wordRepository));
}
