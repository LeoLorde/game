import 'package:flutter/material.dart';
import 'package:game/core/classes/battle.dart';
import 'package:game/core/classes/bot_ai.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/presentation/screens/tela_principal.dart';
import 'package:game/application/audio/audio_manager.dart';

class TelaBatalha extends StatefulWidget {
  final List<Creature> criaturas;

  const TelaBatalha({super.key, required this.criaturas});

  @override
  State<TelaBatalha> createState() => _TelaBatalhaState();
}

class _TelaBatalhaState extends State<TelaBatalha> {
  late BotAI bot;

  Map<Creature, int> playerDeck = {};
  Map<Creature, int> botDeck = {};

  Creature? playerCreature;
  Creature? botCreature;
  @override
  void initState() {
    super.initState();
    deckJogador();
    inicializarBatalha(); // função async separada
    _initBot();
    AudioManager.instance.pushBgm('sounds/som/battle1.mp3');
    AudioManager.instance.popBgm();
  }

  Future<void> _initBot() async {
    bot = await BotAI.criar();
  }

  Future<void> inicializarBatalha() async {
    playerDeck = await deckJogador();
    botDeck = await deckBotMap();

    if (playerDeck.isNotEmpty) {
      playerCreature = playerDeck.keys.first;
    }
    if (botDeck.isNotEmpty) {
      botCreature = botDeck.keys.first;
    }

    setState(() {});
  }

  Future<void> turnoDoBot() async {
    if (botCreature != null && playerCreature != null) {
      final ataqueBot = botCreature!.ataques.first;
      final vidaAtual = playerDeck[playerCreature] ?? 0;
      final novaVida = ataque(ataqueBot, playerCreature!, vidaAtual);
      playerDeck[playerCreature!] = novaVida.clamp(0, vidaAtual);

      setState(() {});
    }
  }

  Color corPorRaridade(Raridade raridade) {
    switch (raridade) {
      case Raridade.combatente:
        return Colors.grey.shade300;
      case Raridade.mistico:
        return Colors.orange.shade200;
      case Raridade.heroi:
        return Colors.purple.shade200;
      case Raridade.semideus:
        return Colors.yellow.shade300;
      default:
        return Colors.white;
    }
  }

  Widget buildCreatureCard(Creature creature, {bool isComposicao = true}) {
    final cor = corPorRaridade(creature.raridade);

    return SizedBox(
      width: 90,
      height: 140,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
        color: cor,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              Text(
                creature.name ?? '???',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Image.asset(
                    creature.getCompletePath(),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Text(
                'Nv. ${creature.level} | HP: ${(playerDeck[creature] ?? botDeck[creature] ?? creature.vida)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildComposicaoBot() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children:
          widget.criaturas.map((creature) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          'JOGAR CRIATURA',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              if (botCreature != null &&
                                  playerCreature != null) {
                                final ataqueEscolhido =
                                    botCreature!.ataques.first;
                                final vidaAtual =
                                    playerDeck[playerCreature] ?? 0;
                                final novaVida = ataque(
                                  ataqueEscolhido,
                                  playerCreature!,
                                  vidaAtual,
                                );
                                playerDeck[playerCreature!] = novaVida.clamp(
                                  0,
                                  vidaAtual,
                                );

                                setState(() {});
                                Navigator.of(context).pop();

                                // Turno do bot
                                await turnoDoBot();
                              }
                            },
                            child: const Text('JOGAR'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('CANCELAR'),
                          ),
                        ],
                      ),
                );
              },
              child: buildCreatureCard(creature),
            );
          }).toList(),
    );
  }

  Widget buildComposicaoPlayer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children:
          widget.criaturas.map((creature) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          'JOGAR CRIATURA',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              if (playerCreature != null &&
                                  botCreature != null) {
                                final ataqueEscolhido =
                                    playerCreature!.ataques.first;
                                final vidaAtual = botDeck[botCreature] ?? 0;
                                final novaVida = ataque(
                                  ataqueEscolhido,
                                  botCreature!,
                                  vidaAtual,
                                );
                                botDeck[botCreature!] = novaVida.clamp(
                                  0,
                                  vidaAtual,
                                );

                                setState(() {});
                                Navigator.of(context).pop();

                                // Turno do bot
                                await turnoDoBot();
                              }
                            },
                            child: const Text('JOGAR'),
                          ),

                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('CANCELAR'),
                          ),
                        ],
                      ),
                );
              },
              child: buildCreatureCard(creature),
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://i.pinimg.com/474x/d5/98/58/d598584bd21317c705cb6e196f974781.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: buildComposicaoBot(),
            ),
          ),

          Center(
            child: Image.network(
              'https://static.vecteezy.com/system/resources/thumbnails/055/577/294/small/red-pixel-art-cross-symbol-isolated-on-transparent-background-png.png',
              width: 280,
              height: 280,
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: buildComposicaoPlayer(),
            ),
          ),
        ],
      ),
    );
  }
}
