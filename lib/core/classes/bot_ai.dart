import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:game/core/models/deck_model.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/core/models/talismans.dart';
import 'package:game/database/app_database.dart';

class BotAI {
  final DeckModel deck;

  BotAI._(this.deck);

  // Cria o Bot com deck
  static Future<BotAI> criar() async {
    final deckBot = await createBotDeck();
    return BotAI._(deckBot);
  }

  // Ataque do Bot
  Future<void> atacar(Attack ataque) async {
    final db = await AppDatabase.instance.getDatabase();

    // Carrega todas as criaturas do bot
    final todasCriaturas = await getTodasCriaturas();
    final criaturasDoBot =
        todasCriaturas.where((c) => deck.cardIds.contains(c.id)).toList();

    for (var criatura in criaturasDoBot) {
      // Calcula dano baseado no elemento e ataque
      final dano = ataque.calcDamage(criatura);

      // Aplica o dano e limita a vida
      criatura.vida = (criatura.vida - dano).clamp(0, criatura.vida);

      // Atualiza no banco
      await db.update(
        'creatures',
        criatura.toMap(),
        where: 'id = ?',
        whereArgs: [criatura.id],
      );
    }
  }
  // final ataqueFogo = Attack('Explosão Flamejante', 40, [Elemento.fogo]);
  // await bot.controlarVida(ataqueFogo);

  List<Talismans> criarTalismasDoBot() {
    // Talismãs básicos que o bot pode utilizar
    final dano = DamageTalismans();
    final defesa = DefenseTalismans();

    return [dano, defesa];
  }

  late final List<Talismans> talismas = criarTalismasDoBot();

  // Controle de vida das criaturas do Bot
  Future<void> controlarVida(Attack ataque) async {
    final db = await AppDatabase.instance.getDatabase();

    final todasCriaturas = await getTodasCriaturas();
    final criaturasDoBot =
        todasCriaturas.where((c) => deck.cardIds.contains(c.id)).toList();

    for (var criatura in criaturasDoBot) {
      // Calcula dano usando a lógica de elementos
      final dano = ataque.calcDamage(criatura);

      // Aplica o dano e limita a vida a no mínimo zero
      criatura.vida = (criatura.vida - dano).clamp(0, criatura.vida);

      // Salva alteração no banco
      await db.update(
        'creatures',
        criatura.toMap(),
        where: 'id = ?',
        whereArgs: [criatura.id],
      );
    }
  }

  // final ataqueFogo = Attack('Explosão Flamejante', 40, [Elemento.fogo]);
  // await bot.controlarVida(ataqueFogo);

  // NÃOSEIIII

  Map<String, dynamic> decidirAcao(
    Creature botCreatureAtiva,
    Creature playerCreatureAtiva,
    Map<Creature, int> botDeck,
  ) {
    // --- Lógica de Decisão Simples ---

    // 1. Avalia o melhor ataque possível com a criatura atual
    Attack? melhorAtaque;
    int maxDano = -1;

    for (var ataque in botCreatureAtiva.ataques) {
      final danoPotencial = ataque.calcDamage(playerCreatureAtiva);
      if (danoPotencial > maxDano) {
        maxDano = danoPotencial;
        melhorAtaque = ataque;
      }
    }

    // Garante que haja um ataque para usar
    melhorAtaque ??= botCreatureAtiva.ataques.first;

    // 2. Decide se vale a pena trocar de criatura
    final vidaAtual = botDeck[botCreatureAtiva] ?? botCreatureAtiva.vida;
    final vidaMaxima = botCreatureAtiva.vida;
    final vidaPercentual = vidaAtual / vidaMaxima;

    // Condição para trocar: vida abaixo de 35% E existe uma criatura melhor no deck
    if (vidaPercentual < 0.35) {
      // Procura por uma criatura com mais vida no deck para trocar
      final criaturasDisponiveis =
          botDeck.entries
              .where(
                (entry) =>
                    entry.key.id != botCreatureAtiva.id &&
                    entry.value > vidaAtual,
              )
              .toList();

      if (criaturasDisponiveis.isNotEmpty) {
        // Ordena para pegar a criatura com mais vida
        criaturasDisponiveis.sort((a, b) => b.value.compareTo(a.value));
        final novaCriatura = criaturasDisponiveis.first.key;

        debugPrint(
          'Bot AI: Vida baixa (${(vidaPercentual * 100).toStringAsFixed(0)}%). Trocando para ${novaCriatura.name}.',
        );
        return {'action': 'switch', 'creature': novaCriatura};
      }
    }

    // 3. Se não trocou, a decisão é atacar com o melhor ataque encontrado
    debugPrint(
      'Bot AI: Decidiu atacar com ${melhorAtaque.name}, dano potencial: $maxDano',
    );
    return {'action': 'attack', 'attack': melhorAtaque};
  }
}

// Pega o deck do jogador
Future<DeckModel?> getDeck() async {
  final db = await AppDatabase.instance.getDatabase();
  final resultado = await db.query('deck', limit: 1);

  if (resultado.isNotEmpty) {
    return DeckModel.fromMap(resultado.first);
  }
  return null;
}

// Pega todas as criaturas salvas no banco
Future<List<Creature>> getTodasCriaturas() async {
  final db = await AppDatabase.instance.getDatabase();
  final resultado = await db.query('creatures');
  return resultado.map((map) => Creature.fromMap(map)).toList();
}

// Pega as criaturas que estão no deck do jogador
List<Creature> getCriaturasDoJogador(
  DeckModel deckPlayer,
  List<Creature> criaturas,
) {
  return criaturas.where((c) => deckPlayer.cardIds.contains(c.id)).toList();
}

// Calcula o nível médio e a faixa alvo
Map<String, dynamic> calculaFaixaNivel(List<Creature> criaturas) {
  if (criaturas.isEmpty) {
    throw Exception('A lista de criaturas está vazia.');
  }
  final niveis = criaturas.map((c) => c.level).toList();
  final nivelMedio = niveis.reduce((a, b) => a + b) ~/ niveis.length;
  final minNivel = (nivelMedio * 0.9).floor();
  final maxNivel = (nivelMedio * 1.1).ceil();

  return {'nivelMedio': nivelMedio, 'minNivel': minNivel, 'maxNivel': maxNivel};
}

// Filtra criaturas compatíveis para o bot
List<Creature> filtraCriaturasParaBot(
  List<Creature> todas,
  List<Raridade> raridadesAlvo,
  int minNivel,
  int maxNivel,
) {
  return todas
      .where(
        (c) =>
            c.level >= minNivel &&
            c.level <= maxNivel &&
            raridadesAlvo.contains(c.raridade),
      )
      .toList();
}

// Cria o deck do bot
Future<DeckModel> createBotDeck() async {
  final deckPlayer = await getDeck();
  if (deckPlayer == null) {
    throw Exception('Deck do jogador não encontrado.');
  }

  final todasCriaturas = await getTodasCriaturas();
  final criaturasDoJogador = getCriaturasDoJogador(deckPlayer, todasCriaturas);

  if (criaturasDoJogador.length < 3) {
    throw Exception('Deck do jogador não possui 3 criaturas.');
  }

  final raridadesAlvo = criaturasDoJogador.map((c) => c.raridade).toList();
  final faixa = calculaFaixaNivel(criaturasDoJogador);

  final criaturasBot = filtraCriaturasParaBot(
    todasCriaturas,
    raridadesAlvo,
    faixa['minNivel'],
    faixa['maxNivel'],
  );

  criaturasBot.shuffle(Random());
  final criaturasSelecionadas = criaturasBot.take(3).toList();

  if (criaturasSelecionadas.length < 3) {
    throw Exception('Não há criaturas suficientes para o bot.');
  }

  final idsSelecionados =
      criaturasSelecionadas.map((c) => c.id).whereType<int>().toList();

  return DeckModel(
    name: 'Deck do Bot',
    cardIds: idsSelecionados,
    playerID: null,
  );
}

// EXEMPLO (que eu não testei, possivelmente errado e não funfa)

// void testarBotDeck() async {
//   try {
//     Cria o deck do bot com base no deck do jogador
//     final deckBot = await createBotDeck();

//     debugPrint('Deck do Bot criado com sucesso!');
//     debugPrint('Nome: ${deckBot.name}');
//     debugPrint('IDs das criaturas: ${deckBot.cardIds}');

//     Buscar todas as criaturas e mostrar detalhes
//     final todasCriaturas = await getTodasCriaturas();

//     for (var id in deckBot.cardIds) {
//       final criatura = todasCriaturas[id];
//       debugPrint(
//         'Criatura [$id]: ${criatura.name}, lvl ${criatura.level}, raridade: ${criatura.raridade.name}',
//       );
//     }
//   } catch (e) {
//     debugPrint('Erro ao criar deck do bot: $e');
//   }
// }
