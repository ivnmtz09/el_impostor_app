import 'dart:convert';
import 'package:floor/floor.dart';

@entity
class Word {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String categoria;
  final String palabra;
  final String pista;

  @ColumnInfo(name: 'es_personalizada')
  final bool esPersonalizada;

  @ColumnInfo(name: 'activa')
  final bool activa;

  Word({
    this.id,
    required this.categoria,
    required this.palabra,
    required this.pista,
    this.esPersonalizada = false,
    this.activa = true,
  });

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        categoria: json["categoria"],
        palabra: json["palabra"],
        pista: json["pista"],
        esPersonalizada: json["esPersonalizada"] ?? false,
        activa: json["activa"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "categoria": categoria,
        "palabra": palabra,
        "pista": pista,
        "esPersonalizada": esPersonalizada,
        "activa": activa,
      };

  Word copyWith({
    int? id,
    String? categoria,
    String? palabra,
    String? pista,
    bool? esPersonalizada,
    bool? activa,
  }) {
    return Word(
      id: id ?? this.id,
      categoria: categoria ?? this.categoria,
      palabra: palabra ?? this.palabra,
      pista: pista ?? this.pista,
      esPersonalizada: esPersonalizada ?? this.esPersonalizada,
      activa: activa ?? this.activa,
    );
  }
}

List<Word> allWordsFromJson(String str) =>
    List<Word>.from(json.decode(str).map((x) => Word.fromJson(x)));
