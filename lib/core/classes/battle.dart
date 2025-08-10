import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:game/database/dao/deck_dao.dart';
import 'package:game/database/dao/creature_dao.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/core/models/deck_model.dart';
import 'package:game/core/classes/bot_ai.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/dimension_enum.dart';

class Battle {
  final String nameJogador;
  final String nameBot;
  final String description;
  final String imageUrl;
  final String backgroundImageUrl;
  final List<int> playerDeckIds;
  final List<int> botDeckIds;

  Battle({
    required this.nameJogador,
    required this.nameBot,
    required this.description,
    required this.imageUrl,
    required this.backgroundImageUrl,
    required this.playerDeckIds,
    required this.botDeckIds,
  });
}

Future<Map<Creature, int>> deckJogador() async {
  List<Creature> cards = await getCardsFromDeck(0);
  Map<Creature, int> map = {};

  for (int i = 0; i < cards.length; i++) {
    map[cards[i]] = cards[i].vida;
  }

  return map;
}

Future<Map<Creature, int>> deckBotMap() async {
  DeckModel enemyDeck = await createBotDeck();
  Map<Creature, int> map = {};

  for (int id in enemyDeck.cardIds) {
    Creature? card = await getCreatureById(id);
    if (card != null) {
      map[card] = card.vida;
    }
  }

  return map;
}

int ataque(Attack attacking_card_attack, Creature defending_card, int health) {
  health -= attacking_card_attack.calcDamage(defending_card);
  return health;
}

// void calcularDano{
//   Implementação do cálculo de dano
// }

Future<MapEntry<Creature, int>> alterarCriatura(int index) {
  final criatura = Creature(
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
  );

  return Future.value(MapEntry(criatura, 2));
}

// void calcularEfeitoBonus{
//   Implementação do cálculo de efeito bônus com base na raridade(seguindo o GDD)
// }

Future<MapEntry<Creature, int>> getRandomPlayerCard() async {
  Map<Creature, int> deck = await deckJogador();
  if (deck.isEmpty) throw Exception('Deck vazio');
  final random = Random();
  return deck.entries.elementAt(random.nextInt(deck.length));
}

Future<MapEntry<Creature, int>> getRandomBotCard() async {
  Map<Creature, int> deck = await deckBotMap();
  if (deck.isEmpty) throw Exception('Deck vazio');
  final random = Random();
  return deck.entries.elementAt(random.nextInt(deck.length));
}

void mainLoop() async {
  //   Implementa o Loop Principal da batalha
  bool playerTurn;
  MapEntry<Creature, int> player_creature = await getRandomPlayerCard();
  MapEntry<Creature, int> bot_creature = await getRandomBotCard();

  final random = Random();
  int numeroAleatorio = random.nextInt(2);

  if (numeroAleatorio == 0) {
    playerTurn = true;
  } else {
    playerTurn = false;
  }

  if (playerTurn) {
    int path;
    // DEPOIS IMPLEMENTAR COM O FRONT, REMOVER ABAIXO
    final random = Random();
    path = random.nextInt(2);
    // ------------------------------------------------
    if (path == 0) {
      // DEPOIS IMPLEMENTAR COM O FRONT, REMOVER ABAIXO
      final random = Random();
      int index = random.nextInt(3);
      // ----------------------------------------------
      player_creature = await alterarCriatura(index);
    } else if (path == 1) {
      // DEPOIS IMPLEMENTAR COM O FRONT, REMOVER ABAIXO
      final random = Random();
      int size = player_creature.key.ataques.length;
      Attack attack = player_creature.key.ataques[random.nextInt(size)];
      // -----------------------------------------------
      ataque(attack, bot_creature.key, bot_creature.value);
      playerTurn = false;
    }
  } else {
    // IMPLEMENTAR COM O BOT AI
  }
}
