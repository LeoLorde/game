import 'package:sqflite/sqflite.dart'; // <- Faltava isso

import 'package:game/core/models/creature_model.dart';
import 'package:game/core/enums/dimension_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/models/attack_model.dart';

class CollectionSeed {
  static final List<Creature> starterCreatures = [
    Creature(
      50,
      1,
      0,
      [Elemento.agua],
      Raridade.combatente,
      [
        Attack("Jatada de Água", 5, [Elemento.agua]),
      ],
      "None",
      "Criatura Padrão de Água",
      DimensionEnum.terra,
    ),
    Creature(
      50,
      1,
      0,
      [Elemento.fogo],
      Raridade.combatente,
      [
        Attack("Rabetada de Fogo", 5, [Elemento.fogo]),
      ],
      "None",
      "Criatura Padrão de Fogo",
      DimensionEnum.terra,
    ),
    Creature(
      50,
      1,
      0,
      [Elemento.terra],
      Raridade.combatente,
      [
        Attack("Espinhos de Terra", 5, [Elemento.terra]),
      ],
      "None",
      "Criatura Padrão de Terra",
      DimensionEnum.terra,
    ),
  ];

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
