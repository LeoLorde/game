import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/database/dao/collection_dao.dart';
import 'package:game/database/dao/deck_dao.dart';
import 'bloc/collection_bloc.dart';
import 'bloc/collection_event.dart';
import 'bloc/collection_state.dart';

import 'bloc/deck_bloc.dart';
import 'bloc/deck_event.dart';
import 'bloc/deck_state.dart';

class ColecaoScreen extends StatelessWidget {
  const ColecaoScreen({super.key});

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
        BlocProvider(create: (_) => DeckBloc()..add(DeckOnStart())),
        BlocProvider(create: (_) => ColecaoBloc()..add(ColecaoOnStart())),
      ],
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 94, 67),
        body: Column(
          children: [
            // ====== Deck (parte de cima) ======
            BlocBuilder<DeckBloc, DeckState>(
              builder: (context, deckState) {
                if (deckState is DeckOnLoading) {
                  return Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (deckState is DeckOnError) {
                  return Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: Text(
                      'Erro ao carregar deck:\n${deckState.message}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (deckState is DeckOnSuccess) {
                  final deck = deckState.criaturas;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
                    color: Colors.blueGrey,
                    height: 250,
                    child: Column(
                      children: [
                        Text(
                          'DECK DE BATALHA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (final creature in deck)
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        backgroundColor: corPorRaridade(
                                          creature.raridade,
                                        ),
                                        title: Text(
                                          creature.name ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              creature.getCompletePath(),
                                              height: 80,
                                            ),
                                            const SizedBox(height: 8),
                                            Text('Nível: ${creature.level}'),
                                            Text(
                                              'Elemento: ${creature.elementos.map((e) => e.name).join(", ")}',
                                            ),
                                            Text(
                                              'Raridade: ${creature.raridade.name}',
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () =>
                                                    Navigator.of(
                                                      dialogContext,
                                                    ).pop(),
                                            child: const Text('Fechar'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(dialogContext).pop();

                                              await removeCreatureFromDeck(
                                                creature.id!,
                                              );
                                              await insertCreatureInCollection(
                                                creature,
                                              );
                                              context.read<ColecaoBloc>().add(
                                                ColecaoOnUpdate(),
                                              );
                                              context.read<DeckBloc>().add(
                                                DeckOnUpdate(),
                                              );
                                            },
                                            child: const Text("Remover"),
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
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 10),

            // ====== Coleção (parte de baixo) ======
            Expanded(
              child: BlocBuilder<ColecaoBloc, ColecaoState>(
                builder: (context, state) {
                  if (state is ColecaoOnLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.tealAccent,
                      ),
                    );
                  }

                  if (state is ColecaoOnError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar coleção:\n${state.message}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  if (state is ColecaoOnSuccess) {
                    final criaturas = state.criaturas;
                    return GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: criaturas.length,
                      itemBuilder: (context, index) {
                        final creature = criaturas[index];
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  backgroundColor: corPorRaridade(
                                    creature.raridade,
                                  ),
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
                                      onPressed:
                                          () =>
                                              Navigator.of(dialogContext).pop(),
                                      child: const Text("Fechar"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await insertCreatureInDeck(creature);
                                        await removeCreatureFromCollection(
                                          creature,
                                        );
                                        Navigator.of(dialogContext).pop();
                                        context.read<ColecaoBloc>().add(
                                          ColecaoOnUpdate(),
                                        );
                                        context.read<DeckBloc>().add(
                                          DeckOnUpdate(),
                                        );
                                      },
                                      child: const Text("Adicionar no Deck"),
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
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
