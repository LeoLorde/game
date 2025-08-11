import 'package:flutter/material.dart';
import 'package:game/core/enums/dimension_enum.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/presentation/screens/tela_batalha.dart';
import 'package:game/presentation/screens/tela_principal.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial>
    with TickerProviderStateMixin {
  void somAbrirBau() {
    AudioManager.tocarEfeito('sounds/som/bau_abrindo.mp3');
  }

  void _mostrarAnimacaoBauDiario() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final controller = AnimationController(
              duration: const Duration(milliseconds: 600),
              vsync: this,
            );
            final animation = IntTween(begin: 1, end: 7).animate(controller);

            controller.forward();

            Future.delayed(const Duration(milliseconds: 800), () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              controller.dispose();
            });

            return Dialog(
              backgroundColor: Colors.transparent,
              child: SizedBox(
                width: 200,
                height: 200,
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final frame = animation.value;
                    return Image.asset(
                      'assets/sprites/baus/1/$frame.png',
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTelaInicial(int trofeus, String tempoBau) {
    return ListView(
      children: [
        Column(
          children: [
            const SizedBox(height: 120),
            Center(
              child: Image.asset(
                'assets/sprites/dimensoes/1.png',
                width: 200,
                height: 300,
              ),
            ),

            Text(
              '$trofeus - 5000',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TelaBatalha(
                          criaturas: [
                            Creature(
                              100,
                              1,
                              10,
                              [Elemento.fogo],
                              Raridade.combatente,
                              [],
                              'aeros_0.png',
                              'Aeros',
                              DimensionEnum.penis,
                            ),
                            Creature(
                              100,
                              1,
                              10,
                              [Elemento.fogo],
                              Raridade.combatente,
                              [],
                              'azuriak_0.png',
                              'Aeros',
                              DimensionEnum.penis,
                            ),
                            Creature(
                              100,
                              1,
                              10,
                              [Elemento.fogo],
                              Raridade.combatente,
                              [],
                              'flarox_0.png',
                              'Aeros',
                              DimensionEnum.penis,
                            ),
                          ],
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 55, 94, 131),
                padding: const EdgeInsets.symmetric(
                  horizontal: 70,
                  vertical: 25,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black, width: 3),
                ),
              ),
              child: Text(
                "LUTAR",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _mostrarAnimacaoBauDiario,
                  child: Image.asset("assets/sprites/baus/1/1.png"),
                ),
                Text(
                  " FALTAM $tempoBau\n PARA SEU BAÚ\n DIÁRIO",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 94, 67),
      body: buildTelaInicial(4571, '18H e 23MIN'),
    );
  }
}
