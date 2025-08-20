import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/core/classes/notification_service.dart';
import 'package:game/core/enums/dimension_enum.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/presentation/screens/init_page/bloc/start_bloc.dart';
import 'package:game/presentation/screens/init_page/bloc/start_event.dart';
import 'package:game/presentation/screens/init_page/bloc/start_state.dart';
import 'package:game/presentation/screens/battle/tela_batalha.dart';
import 'package:game/application/audio/audio_manager.dart';
import 'package:game/presentation/screens/init_page/bloc/player_repository.dart';
import 'package:game/database/dao/deck_dao.dart';

String getDimensaoImagem(int amuletos) {
  if (amuletos >= 4500) {
    return 'assets/sprites/dimensoes/9.png';
  } else if (amuletos >= 4000) {
    return 'assets/sprites/dimensoes/8.png';
  } else if (amuletos >= 3500) {
    return 'assets/sprites/dimensoes/7.png';
  } else if (amuletos >= 3000) {
    return 'assets/sprites/dimensoes/6.png';
  } else if (amuletos >= 2500) {
    return 'assets/sprites/dimensoes/5.png';
  } else if (amuletos >= 2000) {
    return 'assets/sprites/dimensoes/4.png';
  } else if (amuletos >= 1500) {
    return 'assets/sprites/dimensoes/3.png';
  } else if (amuletos >= 1000) {
    return 'assets/sprites/dimensoes/2.png';
  } else if (amuletos >= 500) {
    return 'assets/sprites/dimensoes/1.png';
  } else {
    return 'assets/sprites/dimensoes/0.png';
  }
}

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

          notificationService.scheduleNotification(
            CustomNotification(
              id: 1,
              title: "Baú disponível!",
              body: "Você já pode abrir um novo baú.",
              payload: "/home",
            ),
            const Duration(seconds: 1),
          );
        }
      });
    });
  }

  Widget buildTelaInicial({
    required int amuletos,
    required int cristais,
    required int nivel,
    required String nome,
  }) {
    return ListView(
      children: [
        Column(
          children: [
            const SizedBox(height: 60),
            const SizedBox(height: 10),
            const SizedBox(height: 15),
            Center(
              child: Image.asset(
                'assets/sprites/dimensoes/1.png',
                width: 300,
                height: 300,
                fit: BoxFit.fill,
              ),
            ),
            Text(
              "$amuletos - 5000",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    final deck = await getPDeck();

                    if (deck.length < 3) {
                      // Se não tiver 3 cartas no deck, mostra alerta
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: const Color.fromARGB(
                              255,
                              188,
                              196,
                              196,
                            ),
                            title: const Text("DECK DE BATALHA INCOMPLETO"),
                            content: const Text(
                              "Você precisa de 3 cartas no deck para lutar!",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "OK",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Deck válido -> vai pra batalha
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaBatalha(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC9A400),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70,
                      vertical: 25,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.black, width: 3),
                    ),
                  ),
                  child: const Text(
                    "LUTAR",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _mostrarAnimacaoBauDiario,
                  child: Image.asset(
                    "assets/sprites/baus/1/1.png",
                    height: 120,
                    width: 120,
                    fit: BoxFit.fill,
                  ),
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
    return BlocProvider(
      create: (_) => StartPageBloc(PlayerRepository())..add(StartOnStart()),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sprites/fundo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocBuilder<StartPageBloc, StartState>(
          builder: (context, state) {
            if (state is StartOnLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StartOnError) {
              return Center(child: Text("Erro: ${state.message}"));
            } else if (state is StartOnSuccess) {
              return buildTelaInicial(
                amuletos: state.amuletos,
                cristais: state.cristais,
                nivel: state.nivel,
                nome: state.name,
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
