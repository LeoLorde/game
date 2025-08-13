import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game/core/classes/notification_service.dart';
import 'package:game/core/classes/notification_service.dart';
import 'package:game/core/enums/dimension_enum.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/presentation/screens/tela_batalha.dart';
import 'package:game/application/audio/audio_manager.dart';
import 'package:provider/provider.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial>
    with TickerProviderStateMixin {
  bool bauDisponivel = true;
  int tempoRestante = 0;
  late NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
  }

  void somAbrirBau() async {
    await AudioManager.instance.duckAndPlaySfx('sounds/som/bau_abrindo.mp3');
  }

  void _mostrarAnimacaoBauDiario() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
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

  void _abrirBau() {
    setState(() {
      bauDisponivel = false;
      tempoRestante = 10;
    });

    somAbrirBau();
    _mostrarAnimacaoBauDiario();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        tempoRestante--;
        if (tempoRestante <= 0) {
          bauDisponivel = true;
          timer.cancel();

          // 🔹 Emite notificação quando o baú pode ser aberto de novo
          notificationService.scheduleNotification(
            CustomNotification(
              id: 1,
              title: "Baú disponível!",
              body: "Você já pode abrir um novo baú.",
              payload: "/home",
            ),
            const Duration(seconds: 1), // notifica imediatamente
          );
        }
      });
    });
  }

  Widget buildTelaInicial(int trofeus) {
    return ListView(
      children: [
        Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: Image.asset(
                'assets/sprites/dimensoes/1.png',
                width: 300,
                height: 300,
                fit: BoxFit.fill,
              ),
            ),
            Text(
              '$trofeus - 5000',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
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
              child: const Text(
                "LUTAR",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: bauDisponivel ? _abrirBau : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
              ),
              child: Text(
                bauDisponivel ? "Abrir Baú" : "Aguarde $tempoRestante s",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _mostrarAnimacaoBauDiario,
                  child: Image.asset("assets/sprites/baus/1/1.png"),
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
      body: buildTelaInicial(6969),
    );
  }
}
