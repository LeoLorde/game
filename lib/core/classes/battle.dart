import 'package:game/database/dao/deck_dao.dart';
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

void deckJogador() async {
  List<Creature> cards = await getCardsFromDeck(0);
  // Pega as Cartas do Jogador
}

void deckBot() async{
   DeckModel enemy_cards = await createBotDeck();
   // Pega as Cartas do Inimigo
 }

// void ataque{
//   Implementação do ataque
// }

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
