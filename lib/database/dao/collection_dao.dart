import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../app_database.dart';
import '../../core/models/collection_model.dart';
import '../../core/models/creature_model.dart';
import 'package:game/application/managers/player_manager.dart';
import 'dart:convert';

Future<void> insertCollection(Collection collection_model) async {
  final db = await AppDatabase.instance.getDatabase();
  for (Creature creature in collection_model.creatures) {
    final Map<String, dynamic> data = {
      'vida': creature.vida,
      'level': creature.level,
      'xp': creature.xp,
      'elementos': jsonEncode(
        creature.elementos.map((e) => e.index).toList(),
      ), // Conserta pois o SQFlite não aceita Listas, então fazemos um JSON em String
      'raridade': creature.raridade.index,
      'ataques': jsonEncode(
        creature.ataques.map((a) => a.toMap()).toList(),
      ), // Mesma coisa
      'spriteFile': creature.spriteFile,
      'name': creature.name,
      'dimension': creature.dimension.index,
    };
    await db.insert(
      "collection_creature",
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

Future<void> insertCreatureInCollection(Creature creature) async {
  final db = await AppDatabase.instance.getDatabase();
  final Map<String, dynamic> data = {
    'vida': creature.vida,
    'level': creature.level,
    'xp': creature.xp,
    'elementos': jsonEncode(
      creature.elementos.map((e) => e.index).toList(),
    ), // Conserta pois o SQFlite não aceita Listas, então fazemos um JSON em String
    'raridade': creature.raridade.index,
    'ataques': jsonEncode(
      creature.ataques.map((a) => a.toMap()).toList(),
    ), // Mesma coisa
    'spriteFile': creature.spriteFile,
    'name': creature.name,
    'dimension': creature.dimension.index,
  };
  await db.insert(
    "collection_creature",
    data,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Creature>> getCollection() async {
  debugPrint("Abrindo banco...");
  final db = await AppDatabase.instance.getDatabase();
  print("Banco aberto, buscando dados...");
  final List<Map<String, dynamic>> result = await db.query(
    'collection_creature'
  );
  debugPrint("Dados brutos: $result");
  final List<Creature> creatures =
      result.map((map) => Creature.fromMap(map)).toList();
  debugPrint("Mapeados ${creatures.length} creatures");
  return creatures;
}

Future<void> removeCreatureFromCollection(Creature creature) async {
  final db = await AppDatabase.instance.getDatabase();

  await db.delete(
    'collection_creature',
  );
}

/* Get random creature in collection:
List<Creature> criaturas = getCollection(player_instance.id)
*/
