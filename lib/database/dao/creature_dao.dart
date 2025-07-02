//Manipular dados do banco de dados
import 'dart:convert';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../app_database.dart';
import '../../core/models/creature_model.dart';

// Inserir criaturas no banco de dados
Future<void> insertCreature(Creature creatures) async {
  final db = await AppDatabase.instance.getDatabase();
  await db.insert(
    'creatures',
    creatures.ToMap(), // Salva a criatura convertida em mapa
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Retorna todas as criaturas do banco de dados
// Utiliza o método onLoad para carregar as criaturas
Future<List<Creature>> onLoad() async {
  final db = await AppDatabase.instance.getDatabase();
  final List<Map<String, dynamic>> maps = await db.query('creatures');

  return maps.map((map) {
    return Creature(
      map['vida'],
      map['level'],
      map['xp'],
      // Reconstrói a lista de elementos a partir da string JSON salva no banco
      (jsonDecode(map['elementos']) as List<dynamic>)
          .map((i) => Elemento.values[i])
          .toList(),
      // Reconstrói a raridade a partir do índice salvo
      Raridade.values[map['raridade']],
      // Reconstrói a lista de ataques a partir do JSON salvo
      (jsonDecode(map['ataques']) as List<dynamic>)
          .map((a) => Attack.fromMap(a))
          .toList(),
      map['spriteFile'],
    );
  }).toList();
}
