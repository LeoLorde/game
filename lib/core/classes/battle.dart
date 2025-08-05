import 'package:game/core/models/attack_model.dart';
import 'package:game/database/dao/deck_dao.dart';
import 'package:game/database/dao/creature_dao.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/core/models/deck_model.dart';
import 'package:game/core/classes/bot_ai.dart';

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


int ataque(Attack attacking_card_attack, Creature defending_card, int health){
   health -= attacking_card_attack.calcDamage(defending_card);
   return health;
}

// void vitoria{
//   Implementação da vitória
// }

// void calcularDano{
//   Implementação do cálculo de dano
// }

// void calcularVida{
//   Implementação do cálculo de vida
// }

// void alterarCriatura{
//   Implementação da alteração de criatura
// }

// void talismanesJogador{
//   Implementação dos talismanes do jogador
// }

// void talismanesBot{
//   Implementação dos talismanes do bot
// }

// void usarTalismanes{
//   Implementação do uso de talismanes
// }

// void calcularEfeitoBonus{
//   Implementação do cálculo de efeito bônus com base na raridade(seguindo o GDD)
// }
