import 'package:sqflite/sqflite.dart';
import '../app_database.dart';
import '../../core/models/collection_model.dart';
import '../../core/models/creature_model.dart';

/// Entrada que une um CollectionCard à sua Creature base
class CollectionEntry {
  final CollectionCard card;
  final Creature creature;

  CollectionEntry({required this.card, required this.creature});
}

class CollectionCardDao {
  final dbHelper = AppDatabase.instance;

  /// Insere uma nova carta de coleção
  Future<int> insert(CollectionCard card) async {
    final db = await dbHelper.getDatabase();
    return db.insert(
      'collection_cards',
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Atualiza uma carta existente
  Future<int> update(CollectionCard card) async {
    final db = await dbHelper.getDatabase();
    return db.update(
      'collection_cards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  /// Remove uma carta pelo seu ID
  Future<int> delete(int id) async {
    final db = await dbHelper.getDatabase();
    return db.delete('collection_cards', where: 'id = ?', whereArgs: [id]);
  }

  /// Retorna todas as cartas de coleção (apenas os dados de CollectionCard)
  Future<List<CollectionCard>> getAllCards() async {
    final db = await dbHelper.getDatabase();
    final rows = await db.query('collection_cards');
    return rows.map((r) => CollectionCard.fromMap(r)).toList();
  }

  /// Busca todas as cartas de um mesmo tipo de criatura (pode retornar repetidas)
  Future<List<CollectionCard>> getByCreatureId(int creatureId) async {
    final db = await dbHelper.getDatabase();
    final rows = await db.query(
      'collection_cards',
      where: 'creatureId = ?',
      whereArgs: [creatureId],
    );
    return rows.map((r) => CollectionCard.fromMap(r)).toList();
  }

  /// Retorna cada carta de coleção junto com os dados da criatura base
  Future<List<CollectionEntry>> getAllWithCreature() async {
    final db = await dbHelper.getDatabase();
    final rows = await db.rawQuery('''
      SELECT cc.id    AS cc_id,
             cc.creatureId,
             cc.level AS cc_level,
             cc.xp    AS cc_xp,
             cc.vida  AS cc_vida,
             c.* 
      FROM collection_cards cc
      JOIN creatures c ON cc.creatureId = c.id
    ''');

    return rows.map((r) {
      // Extrai o card
      final card = CollectionCard(
        id: r['cc_id'] as int?,
        creatureId: r['creatureId'] as int,
        level: r['cc_level'] as int,
        xp: (r['cc_xp'] as num).toDouble(),
        vida: r['cc_vida'] as int,
      );

      // Usa o factory padrão de Creature
      final creatureMap = <String, dynamic>{
        'id': r['id'],
        'vida': r['vida'],
        'level': r['level'],
        'xp': r['xp'],
        'elementos': r['elementos'],
        'raridade': r['raridade'],
        'ataques': r['ataques'],
        'spriteFile': r['spriteFile'],
        'name': r['name'],
      };

      final creature = Creature.fromMap(creatureMap);

      return CollectionEntry(card: card, creature: creature);
    }).toList();
  }
}
