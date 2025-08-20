import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'battle_bloc.dart';
import 'battle_event.dart';
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

  Widget buildComposicaoCard(Creature creature, {Key? key}) {
    return SizedBox(
      key: key, // <-- Key única aqui
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
              textAlign: TextAlign.center,
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

  void _showTrocarCriaturaDialog(
    BuildContext context,
    List<Creature> creatures,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Escolha sua nova criatura"),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: creatures.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final creature = creatures[index];
                return GestureDetector(
                  onTap: () {
                    context.read<BattleBloc>().add(
                          PlayerChangeCreature(creature),
                        );
                    Navigator.of(dialogContext).pop();
                  },
                  child: buildComposicaoCard(
                    creature,
                    key: ValueKey(creature.id), // Key aqui também
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
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
            final playerCreatures = state.player_creatures
                .where((c) => c.vida > 0 && c.id != playerCreature.id)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: buildComposicaoCard(
                    playerCreature,
                    key: ValueKey(playerCreature.id), // <-- Key única
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.cached),
                        title: const Text("Trocar Criatura"),
                        subtitle: const Text("Substituir a criatura atual"),
                        onTap: playerCreatures.isEmpty
                            ? null
                            : () => _showTrocarCriaturaDialog(
                                  context,
                                  playerCreatures,
                                ),
                      ),
                      const ListTile(
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

          // Retry automático
          Future.microtask(() {
            context.read<BattleBloc>().add(BattleStarted());
          });
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
