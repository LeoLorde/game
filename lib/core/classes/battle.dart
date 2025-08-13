import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game/core/classes/bot_ai.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:game/database/dao/deck_dao.dart';
import 'package:game/database/dao/creature_dao.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/core/models/deck_model.dart';

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
  List<Creature> cards = await getPDeck();
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
  final dano = attacking_card_attack.calcDamage(defending_card);
  return (health - dano).clamp(0, health);
}

// void calcularDano{
//   Implementação do cálculo de dano
// }

Future<MapEntry<Creature, int>> alterarCriatura(int index) async {
  // Pega apenas as criaturas do deck do jogador
  final deck = await deckJogador();

  if (deck.isEmpty) {
    throw Exception("Nenhuma criatura no deck do jogador");
  }

  // Converte o Map para lista para poder acessar pelo índice
  final listaDeck = deck.entries.toList();

  // Garante que não estoure índice usando o módulo
  final entry = listaDeck[index % listaDeck.length];

  return MapEntry(entry.key, entry.value);
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
    debugPrint('--- TURNO DO BOT ---');
    // 1. Instancia a IA do Bot
    // (O ideal é instanciar o BotAI uma vez no início da batalha)
    final botAI = await BotAI.criar();

    // 2. Obtém o estado atual do deck do bot
    final botDeckCompleto = await deckBotMap();

    // 3. A IA decide a melhor ação a ser tomada
    final acaoBot = botAI.decidirAcao(
      bot_creature.key,
      player_creature.key,
      botDeckCompleto,
    );

    // 4. Executa a ação decidida pela IA
    if (acaoBot['action'] == 'attack') {
      final Attack ataqueEscolhido = acaoBot['attack'];

      debugPrint(
        'Bot usou ${bot_creature.key.name} para atacar com ${ataqueEscolhido.name}!',
      );

      // Aplica o dano na criatura do jogador
      final novaVidaJogador = ataque(
        ataqueEscolhido,
        player_creature.key,
        player_creature.value,
      );
      player_creature = MapEntry(player_creature.key, novaVidaJogador);

      debugPrint(
        'Vida de ${player_creature.key.name} agora é ${player_creature.value}.',
      );
    } else if (acaoBot['action'] == 'switch') {
      final Creature novaCriatura = acaoBot['creature'];

      // Atualiza a criatura ativa do bot
      // Garante que a vida da nova criatura seja pega do estado atual do deck
      final vidaNovaCriatura =
          botDeckCompleto[novaCriatura] ?? novaCriatura.vida;
      bot_creature = MapEntry(novaCriatura, vidaNovaCriatura);

      debugPrint(
        'Bot trocou para ${bot_creature.key.name} com ${bot_creature.value} de vida.',
      );
    }

    // Passa o turno para o jogador
    playerTurn = true;
  }
}
