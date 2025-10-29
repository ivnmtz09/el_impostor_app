import 'dart:convert';

// Función para parsear el JSON de datos
List<Word> allWordsFromJson(String str) =>
    List<Word>.from(json.decode(str).map((x) => Word.fromJson(x)));

class Word {
  final String categoria;
  final String palabra;
  final String pista;

  Word({
    required this.categoria,
    required this.palabra,
    required this.pista,
  });

  // Constructor que crea una instancia de Word desde un mapa JSON
  factory Word.fromJson(Map<String, dynamic> json) => Word(
        categoria: json["categoria"],
        palabra: json["palabra"],
        pista: json["pista"],
      );
}
