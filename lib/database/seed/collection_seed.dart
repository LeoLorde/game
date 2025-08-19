import 'package:sqflite/sqflite.dart'; 

import 'package:game/core/models/creature_model.dart';
import 'package:game/core/enums/dimension_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/models/attack_model.dart';
import 'creature_seed.dart';

class CollectionSeed {
  static final List<Creature> starterCreatures = CreatureSeed.all_creatures;

  Future<void> loadInitialCollection(Database db) async {
    for (Creature creature in starterCreatures) {
      await db.insert(
        'collection_creature',
        creature.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
