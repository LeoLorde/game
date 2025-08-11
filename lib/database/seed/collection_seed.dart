import 'package:game/core/models/creature_model.dart';
import 'package:game/database/seed/creature_seed.dart';
import 'package:game/database/dao/collection_dao.dart';

class CollectionSeed {
  // Define as criaturas iniciais para o jogador
  static final List<Creature> starterCreatures = [
    CreatureSeed.all_creatures[0],
    CreatureSeed.all_creatures[1],
  ];

  CollectionSeed();

  Future<void> loadInitialCollection() async {
    for (Creature creature in starterCreatures) {
      await insertCreatureInCollection(creature);
    }
  }
}
