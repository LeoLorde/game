import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:game/presentation/screens/tela_loja.dart';
import 'package:game/application/managers/player_manager.dart';
import 'package:game/database/dao/collection_dao.dart'; // ajuste se estiver em outro lugar

class ColecaoScreen extends StatefulWidget {
  const ColecaoScreen({super.key});

  @override
  State<ColecaoScreen> createState() => _ColecaoScreenState();
}

class _ColecaoScreenState extends State<ColecaoScreen> {
  List<Creature> _criaturas = [];
  bool _isLoading = true;

  final img = 'assets/sprites/bintilin.png';

  final cores = [
    const Color.fromARGB(255, 42, 134, 24),
    const Color.fromARGB(255, 55, 94, 131),
    const Color.fromARGB(255, 134, 68, 24),
  ];

  @override
  void initState() {
    super.initState();
    _carregarColecao();
  }

  Future<void> _carregarColecao() async {
    final criaturas = await getCollection(0);
    setState(() {
      _criaturas = criaturas;
      _isLoading = false;
    });
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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    backgroundColor: cor,
                                    title: const Text(
                                      'BINTILIN',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(img, height: 80),
                                        const SizedBox(height: 8),
                                        const Text('Nível: 24'),
                                        const Text('Elemento: Planta'),
                                        const Text('Raridade: Épica'),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(dialogContext).pop(),
                                        child: const Text('Fechar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: buildComposicaoCard(
                              img,
                              24,
                              cor,
                              'BINTILIN',
                            ),
                          ),
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
                  itemCount: _criaturas.length,
                  itemBuilder: (context, index) {
                    final creature = _criaturas[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              backgroundColor: Colors.teal.shade50,
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
                                      (atk) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "- ${atk.name} (ATK: ${atk.base_damage})",
                                          ),
                                        ],
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
                              ],
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(creature.getCompletePath()),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            creature.name ?? '',
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
