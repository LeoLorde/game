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
    Creature(
      50,
      1,
      0,
      [Elemento.ar],
      Raridade.combatente,
      [
        Attack("Corte de Vento", 5, [Elemento.ar]),
      ],
      "None",
      "Criatura Padrão de Ar",
      DimensionEnum.terra,
    ),
    Creature(
      50,
      1,
      0,
      [Elemento.agua, Elemento.fogo],
      Raridade.combatente,
      [
        Attack("Jatada de Água", 10, [Elemento.agua]),
      ],
      "None",
      "Criatura de Fusão Água e Fogo",
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
