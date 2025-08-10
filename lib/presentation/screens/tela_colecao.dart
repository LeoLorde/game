import 'package:flutter/material.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/creature_model.dart';

class ColecaoScreen extends StatefulWidget {
  final List<Creature> criaturas;

  const ColecaoScreen({super.key, required this.criaturas});

  @override
  State<ColecaoScreen> createState() => _ColecaoScreenState();
}

class _ColecaoScreenState extends State<ColecaoScreen> {
  final List<Color> cores = [
    const Color.fromARGB(255, 42, 134, 24),
    const Color.fromARGB(255, 55, 94, 131),
    const Color.fromARGB(255, 134, 68, 24),
  ];

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

  void mostrarDialogoCreature(Creature creature) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.teal.shade50,
            title: Text(
              creature.name ?? "Criatura",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(creature.getCompletePath(), height: 100),
                  const SizedBox(height: 8),
                  Text("Nível: ${creature.level}"),
                  Text("Raridade: ${creature.raridade.name.toUpperCase()}"),
                  Text("Vida: ${creature.vida}"),
                  const SizedBox(height: 12),
                  const Text(
                    "Ataques:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  ...creature.ataques.map(
                    (atk) => Text("- ${atk.name} (ATK: ${atk.base_damage})"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Fechar"),
              ),
            ],
          ),
    );
  }

  Widget buildCreatureCard(Creature creature, {bool isComposicao = false}) {
    final cor = corPorRaridade(creature.raridade);

    return SizedBox(
      width: 120,
      height: 170,
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
                'Nv. ${creature.level}',
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

  Widget buildTalismanCard(String imageUrl) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(8),
        child: Image.network(imageUrl),
      ),
    );
  }

  Widget buildTalismans() {
    final icones = List.filled(
      5,
      'https://cdn-icons-png.flaticon.com/512/833/833472.png',
    );
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: icones.map(buildTalismanCard).toList(),
    );
  }

  Widget buildComposicao() {
    return Column(
      children: [
        const Text(
          'COMPOSIÇÃO DE BATALHA',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              cores.map((cor) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text(
                              'EXCLUIR CARTA DA COMPOSIÇÃO?',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('EXCLUIR'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('CANCELAR'),
                              ),
                            ],
                          ),
                    );
                  },
                  child: buildCreatureCard(widget.criaturas.first),
                );
              }).toList(),
        ),
        const SizedBox(height: 20),
        buildTalismans(),
      ],
    );
  }

  Widget buildColecao() {
    return SizedBox(
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
        itemBuilder: (_, index) {
          final creature = widget.criaturas[index];
          return GestureDetector(
            onTap: () => mostrarDialogoCreature(creature),
            child: buildCreatureCard(creature),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 94, 67),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            color: Colors.blueGrey,
            child: buildComposicao(),
          ),
          const SizedBox(height: 10),
          buildColecao(),
        ],
      ),
    );
  }
}
