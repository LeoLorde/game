import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'battle_bloc.dart';
import 'battle_state.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/creature_model.dart';

class BattleScreen extends StatelessWidget {
  const BattleScreen({super.key});

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

  Widget buildComposicaoCard(Creature creature) {
    return SizedBox(
      width: 140,
      height: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
        color: corPorRaridade(creature.raridade),
        child: Column(
          children: [
            Text(
              creature.name ?? "Criatura",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Image.asset(
                creature.getCompletePath(),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Nv. ${creature.level}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              'Vida: ${creature.vida}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
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
    return Scaffold(
      appBar: AppBar(title: const Text("Batalha")),
      body: BlocBuilder<BattleBloc, BattleState>(
        builder: (context, state) {
          if (state is BattleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BattleError) {
            return Center(child: Text(state.message));
          }

          if (state is BattleSuccess) {
            final playerCreature = state.player_selected; 
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: buildComposicaoCard(playerCreature),
                ),

                const Divider(),

                Expanded(
                  child: ListView(
                    children: const [
                      ListTile(
                        leading: Icon(Icons.cached),
                        title: Text("Trocar Criatura"),
                        subtitle: Text("Substituir a criatura atual"),
                      ),
                      ListTile(
                        leading: Icon(Icons.flash_on),
                        title: Text("Atacar"),
                        subtitle: Text("Usar um dos ataques disponíveis"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text("Esperando iniciar batalha..."));
        },
      ),
    );
  }
}
