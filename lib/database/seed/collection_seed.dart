import 'package:sqflite/sqflite.dart'; 
import 'package:game/core/models/creature_model.dart';
import 'creature_seed.dart';

class CollectionSeed {
  static final List<Creature> starterCreatures = CreatureSeed.all_creatures;

  Future<void> loadInitialCollection(Database db) async {
    starterCreatures.shuffle();
    final selectedCreatures = starterCreatures.take(3).toList();

    for (Creature creature in selectedCreatures) {
      await db.insert(
        'collection_creature',
        creature.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
