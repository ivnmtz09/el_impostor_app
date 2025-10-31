import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:el_impostor_app/core/database/app_database.dart';
import 'package:el_impostor_app/data/repositories/word_repository.dart';
import 'package:el_impostor_app/presentation/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen muestra el botón INICIAR JUEGO',
      (WidgetTester tester) async {
    // Crear una base de datos en memoria para testing
    final database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();

    // Crear el repositorio
    final wordRepository = WordRepository(database);

    // Build our HomeScreen inside a MaterialApp with the repository
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(wordRepository: wordRepository),
      ),
    );

    // Espera a que cargue (como la BD está vacía, carga rápido)
    await tester.pumpAndSettle();

    // Verifica que exista el botón INICIAR JUEGO
    expect(find.text('INICIAR JUEGO'), findsOneWidget);
  });
}
