import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:el_impostor_app/app.dart';
import 'package:el_impostor_app/core/database/app_database.dart';
import 'package:el_impostor_app/core/services/feedback_service.dart';
import 'package:el_impostor_app/data/local/database_initializer.dart';
import 'package:el_impostor_app/data/repositories/word_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Forzar orientación vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configurar tema del sistema
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Inicializar base de datos
  final database = await AppDatabase.buildDatabase();
  await DatabaseInitializer.initialize(database);
  final wordRepository = WordRepository(database);

  // Precargar sonidos (sin await para evitar bloqueo si los archivos son placeholders)
  FeedbackService.preloadSounds();

  runApp(ElImpostorApp(wordRepository: wordRepository));
}
