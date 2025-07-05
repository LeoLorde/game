import 'package:flutter/material.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/presentation/screens/tela_loja.dart';

class ColecaoScreen extends StatefulWidget {
  final List<Creature> criaturas;

  ColecaoScreen({super.key, required this.criaturas});

  @override
  State<ColecaoScreen> createState() => _ColecaoScreenState();
}

class _ColecaoScreenState extends State<ColecaoScreen> {
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
          side: BorderSide(color: Colors.black, width: 2),
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
            Expanded(child: Image.asset('$img')),
            const SizedBox(height: 7),
            Text(
              'Nv. ${level}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  final img = 'assets/sprites/bintilin.png';

  final cores = [
    const Color.fromARGB(255, 42, 134, 24),
    const Color.fromARGB(255, 55, 94, 131),
    const Color.fromARGB(255, 134, 68, 24),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 94, 67),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 100,
                  horizontal: 15,
                ),
                color: Colors.blueGrey,
                child: Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var cor in cores)
                          buildComposicaoCard(img, 24, cor, 'BINTILIN'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: widget.criaturas.length,
                  itemBuilder: (context, index) {
                    final creature = widget.criaturas[index];
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
