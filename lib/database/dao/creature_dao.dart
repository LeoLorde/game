import 'dart:convert';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:sqflite/sqflite.dart';
import '../app_database.dart';
import '../../core/models/creature_model.dart';

// Inserir criatura no banco de dados, convertendo listas para String JSON
Future<void> insertCreature(Creature creature) async {
  final db = await AppDatabase.instance.getDatabase();

  // Converte listas para String JSON antes de inserir
  final Map<String, dynamic> data = {
    'vida': creature.vida,
    'level': creature.level,
    'xp': creature.xp,
    'elementos': jsonEncode(creature.elementos.map((e) => e.index).toList()), // Conserta pois o SQFlite não aceita Listas, então fazemos um JSON em String
    'raridade': creature.raridade.index,
    'ataques': jsonEncode(creature.ataques.map((a) => a.toMap()).toList()), // Mesma coisa
    'spriteFile': creature.spriteFile,
    'name':creature.name
  };

  await db.insert(
    'creatures',
    data,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Carrega todas as criaturas do banco
Future<List<Creature>> onLoad() async {
  final db = await AppDatabase.instance.getDatabase();
  final List<Map<String, dynamic>> maps = await db.query('creatures');

  return maps.map((map) {
    // Decodifica as Strings JSON para listas/enums corretos
    final elementosJson = jsonDecode(map['elementos'] as String) as List<dynamic>;
    final ataquesJson = jsonDecode(map['ataques'] as String) as List<dynamic>;

    return Creature(
      map['vida'] as int,
      map['level'] as int,
      (map['xp'] as num).toDouble(),
      elementosJson.map((i) => Elemento.values[i as int]).toList(),
      Raridade.values[map['raridade'] as int],
      ataquesJson.map((a) => Attack.fromMap(a as Map<String, dynamic>)).toList(),
      map['spriteFile'] as String,
      map['name'] as String
    );
  }).toList();
}
