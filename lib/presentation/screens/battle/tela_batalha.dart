import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/database/dao/deck_dao.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/creature_model.dart';
import 'bloc/battle_bloc.dart';
import 'bloc/battle_event.dart';
import 'bloc/battle_state.dart';
import 'bloc/deck_bloc.dart';
import 'bloc/deck_event.dart';
import 'bloc/deck_state.dart';

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
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Batalha')),
        body: BlocBuilder<DeckBloc, DeckState>(
          builder: (context, state) {
            if (state is DeckOnLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DeckOnError) {
              return Center(
                child: Text('Erro ao carregar deck: ${state.message}'),
              );
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

                  // As 3 cartas do deck
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final creature in deck.take(3))
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
      ),
    );
  }
}
