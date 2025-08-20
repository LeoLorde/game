import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/creature_model.dart';
import 'bloc/battle_bloc.dart';
import 'bloc/battle_event.dart';
import 'bloc/battle_state.dart';
import 'bloc/deck_bloc.dart';
import 'bloc/deck_event.dart';
import 'bloc/deck_state.dart';
import 'bloc/bot_bloc.dart';
import 'bloc/bot_event.dart';
import 'bloc/bot_state.dart';

class TelaBatalha extends StatelessWidget {
  const TelaBatalha({super.key});

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

  Widget buildComposicaoCard(
    String imageUrl,
    int level,
    Color cor,
    String nome,
  ) {
    return SizedBox(
      width: 120,
      height: 170,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
        color: cor,
        child: Column(
          children: [
            Text(
              nome,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Expanded(child: Image.asset(imageUrl)),
            const SizedBox(height: 7),
            Text(
              'Nv. $level',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BattleBloc()..add(BattleStarted())),
        BlocProvider(create: (_) => DeckBloc()..add(DeckOnStart())),
        BlocProvider(create: (_) => BotBloc()..add(BotOnStart())),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Batalha')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ==== CARTAS DO BOT ====
            BlocBuilder<BotBloc, BotState>(
              builder: (context, state) {
                if (state is BotOnLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is BotOnError) {
                  return Text('Erro ao carregar bot: ${state.message}');
                }

                if (state is BotOnSuccess) {
                  final deckBot = state.criaturas;

                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Cartas do Bot",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final creature in deckBot.take(3))
                            buildComposicaoCard(
                              creature.getCompletePath(),
                              creature.level,
                              corPorRaridade(creature.raridade),
                              creature.name ?? '',
                            ),
                        ],
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),

            // ==== CARTAS DO JOGADOR ====
            BlocBuilder<DeckBloc, DeckState>(
              builder: (context, state) {
                if (state is DeckOnLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is DeckOnError) {
                  return Text('Erro ao carregar deck: ${state.message}');
                }

                if (state is DeckOnSuccess) {
                  final deck = state.criaturas;

                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Suas Cartas",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final creature in deck.take(3))
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      backgroundColor:
                                          corPorRaridade(creature.raridade),
                                      title: Text(
                                        creature.name ?? "Criatura",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              creature.getCompletePath(),
                                              height: 100,
                                            ),
                                            const SizedBox(height: 8),
                                            Text("Nível: ${creature.level}"),
                                            Text(
                                              "Raridade: ${creature.raridade.name.toUpperCase()}",
                                            ),
                                            Text("Vida: ${creature.vida}"),
                                            const SizedBox(height: 12),
                                            const Text(
                                              "Ataques:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            ...creature.ataques.map(
                                              (atk) => Text(
                                                "- ${atk.name} (ATK: ${atk.base_damage})",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(dialogContext).pop(),
                                          child: const Text("Fechar"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: const Text("Jogar Criatura"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: buildComposicaoCard(
                                creature.getCompletePath(),
                                creature.level,
                                corPorRaridade(creature.raridade),
                                creature.name ?? '',
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
