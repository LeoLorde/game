import 'dart:convert';
import 'package:game/core/models/creature_model.dart';
import 'package:game/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

/// Insere uma criatura no deck (máximo de 3 criaturas)
Future<void> insertCreatureInDeck(Creature creature) async {
  final db = await AppDatabase.instance.getDatabase();

  final currentDeck = await db.query('deck');
  if (currentDeck.length >= 3) {
    throw Exception('O deck pode ter no máximo 3 criaturas.');
  }

  final Map<String, dynamic> data = {
    'vida': creature.vida,
    'level': creature.level,
    'xp': creature.xp,
    'elementos': jsonEncode(
      creature.elementos.map((e) => e.index).toList(),
    ),
    'raridade': creature.raridade.index,
    'ataques': jsonEncode(
      creature.ataques.map((a) => a.toMap()).toList(),
    ),
    'spriteFile': creature.spriteFile,
    'name': creature.name,
    'dimension': creature.dimension.index,
  };

  await db.insert(
    'deck',
    data,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

/// Retorna todas as criaturas do deck
Future<List<Creature>> getPDeck() async {
  final db = await AppDatabase.instance.getDatabase();
  final List<Map<String, dynamic>> result = await db.query('deck');
  return result.map((map) => Creature.fromMap(map)).toList();
}

/// Remove uma criatura específica do deck
Future<void> removeCreatureFromDeck(int id) async {
  final db = await AppDatabase.instance.getDatabase();
  await db.delete(
    'deck',
    where: 'id = ?',
    whereArgs: [id],
  );
}

/// Remove todas as criaturas do deck
Future<void> clearDeck() async {
  final db = await AppDatabase.instance.getDatabase();
  await db.delete('deck');
}
