import 'package:flutter/material.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:game/core/models/creature_model.dart';

class ColecaoScreen extends StatelessWidget {
  final List<Creature> criaturas;

  ColecaoScreen({super.key, required this.criaturas});

  Color corPorRaridade(Raridade raridade) {
    switch (raridade) {
      case Raridade.comum:
        return Colors.grey.shade300;
      case Raridade.rara:
        return Colors.orange.shade200;
      case Raridade.epica:
        return Colors.purple.shade200;
      case Raridade.lendaria:
        return Colors.yellow.shade300;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Coleção de Criaturas"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.teal.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("TAaa", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Nível: 10"),
                Text("Cristais: 10000000"),
                Text("Amuletos: 1000000"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                DetalheCriaturaScreen(creature: creature),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: corPorRaridade(creature.raridade),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(creature.getCompletePath()),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '"NOME DO BICHO"',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Nv. ${creature.level}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetalheCriaturaScreen extends StatelessWidget {
  final Creature creature;

  const DetalheCriaturaScreen({super.key, required this.creature});

  Widget _buildAttackTile(BuildContext context, Attack atk) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text(atk.name),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ATK: ${atk.base_damage}"),
                    const SizedBox(height: 8),
                    const Text(
                      "Bônus: Acumula 15% de ataque para o próximo turno",
                    ),
                  ],
                ),
              ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(atk.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("ATK: ${atk.base_damage}"),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children:
                  atk.elementos
                      .map((e) => Icon(_getIcon(e), size: 16))
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(Elemento e) {
    switch (e) {
      case Elemento.fogo:
        return Icons.local_fire_department;
      case Elemento.terra:
        return Icons.landscape;
      case Elemento.agua:
        return Icons.water;
      case Elemento.planta:
        return Icons.eco;
      default:
        return Icons.blur_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Detalhes da Criatura"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.teal.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text(
                  "Yang_XuXu",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Nível: 24"),
                Text("Cristais: 4876"),
                Text("Amuletos: 4571"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Image.asset(creature.getCompletePath(), height: 120),
          Text(
            '"NOME DO BICHO"',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "Nível ${creature.level} - ${creature.raridade.name.toUpperCase()}",
          ),
          Text("Vida: ${creature.vida}"),
          const SizedBox(height: 10),
          const Text("ATAQUES", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children:
                  creature.ataques
                      .map((atk) => _buildAttackTile(context, atk))
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
