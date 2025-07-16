import 'dart:convert';
import 'package:game/core/enums/dimension_enum.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:sqflite/sqflite.dart';
import '../app_database.dart';
import '../../core/models/creature_model.dart';

// Inserir criatura no banco de dados, convertendo listas para String JSON
Future<void> insertCreature(Creature creature, String table) async {
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
    'name':creature.name,
    'dimension':creature.dimension.index
  };

  await db.insert(
    table,
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
      map['name'] as String,
      DimensionEnum.values[map['dimension'] as int]
    );
  }).toList();
}

// Função para pegar a PRIMEIRA criatura inserida com o nome selecionado
Future<Creature?> getCreatureByName(String name) async {
  final db = await AppDatabase.instance.getDatabase(); // Aguarda o db
  // Faz a requisição pro Banco de Dados
  final List<Map<String, dynamic>> maps = await db.query(
    'creatures', 
    where: 'name = ?',
    whereArgs: [name],
    limit: 1,
  );

  // Caso não achar nada, retorne nulo
  if (maps.isEmpty) return null;

  final map = maps.first; // Caso achar, pegue o primeiro Map (Dados da Criatura)
  final elementosJson = jsonDecode(map['elementos'] as String) as List<dynamic>; // Decoda o JSON das Listas
  final ataquesJson = jsonDecode(map['ataques'] as String) as List<dynamic>; // Decoda o JSON dos Ataques

  // Retorna a Criatura encontrada  
  return Creature(
    map['vida'] as int,
    map['level'] as int,
    (map['xp'] as num).toDouble(),
    elementosJson.map((i) => Elemento.values[i as int]).toList(),
    Raridade.values[map['raridade'] as int],
    ataquesJson.map((a) => Attack.fromMap(a as Map<String, dynamic>)).toList(),
    map['spriteFile'] as String,
    map['name'] as String,
    DimensionEnum.values[map['dimension'] as int]
  );
}
