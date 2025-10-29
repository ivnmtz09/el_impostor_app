// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:el_impostor_app/presentation/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen muestra el botón INICIAR JUEGO',
      (WidgetTester tester) async {
    // Build our HomeScreen inside a MaterialApp and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Espera el frame inicial
    await tester.pumpAndSettle();

    // Verifica que exista el botón INICIAR JUEGO
    expect(find.text('INICIAR JUEGO'), findsOneWidget);
  });
}
