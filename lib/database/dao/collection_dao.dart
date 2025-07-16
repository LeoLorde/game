import 'package:sqflite/sqflite.dart';
import '../app_database.dart';
import '../../core/models/collection_model.dart';
import '../../core/models/creature_model.dart';
import 'package:game/database/dao/creature_dao.dart';
import 'package:game/database/app_database.dart';
import 'package:game/application/managers/player_manager.dart';
import 'dart:convert';

Future<void> insertCollection(Collection collection_model) async {
  final db = await AppDatabase.instance.getDatabase();
  for(Creature creature in collection_model.creatures){
    final Map<String, dynamic> data = {
    'vida': creature.vida,
    'level': creature.level,
    'xp': creature.xp,
    'elementos': jsonEncode(creature.elementos.map((e) => e.index).toList()), // Conserta pois o SQFlite não aceita Listas, então fazemos um JSON em String
    'raridade': creature.raridade.index,
    'ataques': jsonEncode(creature.ataques.map((a) => a.toMap()).toList()), // Mesma coisa
    'spriteFile': creature.spriteFile,
    'name':creature.name,
    'dimension':creature.dimension.index,
    'player_id':player_instance!.id
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
    'elementos': jsonEncode(creature.elementos.map((e) => e.index).toList()), // Conserta pois o SQFlite não aceita Listas, então fazemos um JSON em String
    'raridade': creature.raridade.index,
    'ataques': jsonEncode(creature.ataques.map((a) => a.toMap()).toList()), // Mesma coisa
    'spriteFile': creature.spriteFile,
    'name':creature.name,
    'dimension':creature.dimension.index,
    'player_id':player_instance!.id
  };
  await db.insert(
    "collection_creature",
    data,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}