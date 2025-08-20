import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:game/database/app_database.dart';
import 'package:game/database/dao/creature_dao.dart';
import 'package:game/core/enums/dimension_enum.dart';

class CreatureSeed {
  // Cria um MAP com todas as criaturas. ALTERAR AQUI QUANDO CRIAR UMA NOVA CRIATURA
  // As criaturas atuais SÃO GENÉRICAS, apenas para Testes e garantia que o sistema FUNCIONA
  static final List<Creature> all_creatures = [
    Creature(
      50,
      1,
      0,
      [Elemento.agua],
      Raridade.combatente,
      [
        Attack("Jatada de Água", 5, [Elemento.agua]),
      ],
      "azuriak",
      "Azuriak",
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
      "ignarok",
      "Ignarok",
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
      "pedruna",
      "Pedruna",
      DimensionEnum.terra,
    ),
    Creature(
      50,
      1,
      0,
      [Elemento.ar],
      Raridade.combatente,
      [
        Attack("Corte de Vento", 5, [Elemento.ar]),
      ],
      "aeros",
      "Aeros",
      DimensionEnum.terra,
    ),
    Creature(
      100,
      1,
      0,
      [Elemento.terra, Elemento.fogo],
      Raridade.heroi,
      [
        Attack("Rajada de Lava", 15, [Elemento.terra, Elemento.fogo]),
        Attack("Terremoto de Magma", 20, [Elemento.fogo])
      ],
      "flarox",
      "Flarox",
      DimensionEnum.terra,
    ),
    Creature(
      100,
      1,
      0,
      [Elemento.ar, Elemento.fogo],
      Raridade.heroi,
      [
        Attack("Tornado de Fogo", 15, [Elemento.ar, Elemento.fogo]),
        Attack("Corte de Vento", 20, [Elemento.ar])
      ],
      "pyroair",
      "Pyroair",
      DimensionEnum.terra,
    ),
    Creature(
      75,
      1,
      0,
      [Elemento.terra],
      Raridade.combatente,
      [
        Attack("Pedrada de Terra", 15, [Elemento.terra]),
        Attack("Terrada de Pedra", 20, [Elemento.terra])
      ],
      "rhyno",
      "Rhyno",
      DimensionEnum.terra,
    ),
    Creature(
      50,
      1,
      0,
      [Elemento.planta],
      Raridade.combatente,
      [
        Attack("Flores de Hiroshima", 25, [Elemento.planta]),
      ],
      "verdalisk",
      "Verdalisk",
      DimensionEnum.terra,
    ),
    Creature(
      250,
      1,
      0,
      [Elemento.planta, Elemento.agua],
      Raridade.mistico,
      [
        Attack("Ervas Venenosas", 35, [Elemento.planta]),
        Attack("Tiro de Água", 35, [Elemento.agua]),
        Attack("Raízes Marinhas", 25, [Elemento.planta, Elemento.agua])
      ],
      "danimar",
      "Danimar",
      DimensionEnum.terra,
    ),
    Creature(
      40,
      1,
      0,
      [Elemento.planta, Elemento.planta],
      Raridade.heroi,
      [
        Attack("Ervas Venenosas", 35, [Elemento.planta]),
        Attack("Flores de Banana", 25, [Elemento.planta, Elemento.planta]),
      ],
      "flora",
      "Flora",
      DimensionEnum.terra,
    ),
    Creature(
      50,
      1,
      0,
      [Elemento.fogo],
      Raridade.combatente,
      [
        Attack("Raba pegando Fogo", 35, [Elemento.fogo]),
      ],
      "ignis",
      "Ignis",
      DimensionEnum.terra,
    ),
    Creature(
      50,
      1,
      0,
      [Elemento.terra],
      Raridade.combatente,
      [
        Attack("Espinho Cilíndrico", 35, [Elemento.terra]),
      ],
      "laranjariak",
      "Laranjariak",
      DimensionEnum.terra,
    ),
    Creature(
      50,
      1,
      0,
      [Elemento.planta],
      Raridade.combatente,
      [
        Attack("Primavera", 35, [Elemento.planta]),
      ],
      "leafy",
      "Leafy",
      DimensionEnum.terra,
    ),
  ];

  CreatureSeed();

  // Adiciona todas as Criaturas ao Banco de Dados
  Future<void> loadCreaturesOnDb() async {
    for (Creature criatura in all_creatures) {
      await insertCreature(criatura, 'creatures');
    }
  }
}
