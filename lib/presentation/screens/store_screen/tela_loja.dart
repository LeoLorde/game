import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/application/audio/audio_manager.dart';
import 'package:game/core/models/jogador_model.dart';
import 'package:game/core/models/loja_model.dart';
import 'package:game/database/app_database.dart' as database;
import 'package:game/database/dao/loja_dao.dart';
import 'package:game/presentation/screens/store_screen/bloc/store_bloc.dart';
import 'package:game/presentation/screens/store_screen/bloc/store_state.dart';
import 'package:game/presentation/screens/store_screen/bloc/store_event.dart';
import 'package:game/core/models/jogador_model.dart' as jogador_model;
import 'package:game/database/dao/jogador_dao.dart' as jogador_dao;
import 'package:sqflite/sqflite.dart';

class TelaLoja extends StatefulWidget {
  const TelaLoja({Key? key}) : super(key: key);

  @override
  _TelaLojaState createState() => _TelaLojaState();
}

class _TelaLojaState extends State<TelaLoja> {
  void somAbrirBau() {
    AudioManager.instance.playSfx('sounds/som/bau_abrindo.mp3');
  }

  void _mostrarAnimacaoBau(BuildContext context) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: Navigator.of(context),
    );
    final animation = IntTween(begin: 1, end: 7).animate(controller);
    controller.forward();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: SizedBox(
              width: 200,
              height: 200,
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  final frame = animation.value;
                  return Image.asset(
                    'assets/sprites/baus/3/$frame.png',
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
          ),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      controller.dispose();
    });
  }

  Widget buildItemCard(BuildContext context, Loja item, Color cor) {
    final bloc = context.read<LojaBloc>();
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                backgroundColor: const Color.fromARGB(255, 54, 145, 99),
                title: const Text("CONFIRMAR COMPRA"),
                content: Text(
                  "DESEJA COMPRAR ESTE ITEM POR ${item.preco} CRISTAIS?",
                ),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("CANCELAR"),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();

                      comprarItem(item.id!, bloc);

                      if (item.tipo == 'bau') {
                        _mostrarAnimacaoBau(context);
                        somAbrirBau();
                      }
                    },
                    child: const Text("COMPRAR"),
                  ),
                ],
              ),
        );
      },
      child: SizedBox(
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
              Expanded(
                child: Image.asset(
                  item.tipo == 'bau'
                      ? 'assets/sprites/baus/3/1.png'
                      : 'assets/sprites/aeros_0.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                '${item.preco}',
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bannerUrl =
        'https://images.vexels.com/media/users/3/137099/isolated/preview/0e0ef8c04e05e38562aeba6544c59e29-banner-de-fita-de-doodle-ondulado.png';

    final cores = [
      const Color.fromARGB(255, 42, 134, 24),
      const Color.fromARGB(255, 55, 94, 131),
      const Color.fromARGB(255, 134, 68, 24),
    ];

    return BlocProvider(
      create: (_) => LojaBloc()..add(LojaStarted()),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 94, 67),
        body: BlocBuilder<LojaBloc, LojaState>(
          builder: (context, state) {
            if (state is LojaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LojaError) {
              return Center(
                child: Text(
                  'Erro: ${state.message}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (state is LojaSuccess) {
              final itens = state.itens;
              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  Center(
                    child: Image.network(bannerUrl, height: 200, width: 200),
                  ),
                  const SizedBox(height: 16),
                  if (itens.isEmpty)
                    const Center(
                      child: Text(
                        'LOJA VAZIA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: List.generate(itens.length, (index) {
                        final item = itens[index];
                        return buildItemCard(
                          context,
                          item,
                          cores[index % cores.length],
                        );
                      }),
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

Future<void> comprarItem(int itemId, LojaBloc bloc) async {
  final Database db = await database.AppDatabase.instance.getDatabase();

  try {
    final lojaDao = LojaDao(db);
    final item = await lojaDao.buscarPorId(itemId);
    if (item == null) {
      throw Exception("Item não encontrado na loja.");
    }

    final jogadorDao = jogador_dao.JogadorDao(db);
    final jogador = await jogadorDao.buscar();
    if (jogador == null || jogador.cristais < item.preco) {
      throw Exception("Créditos insuficientes.");
    }

    // Atualiza os cristais do jogador
    final novosCristais = jogador.cristais - item.preco;
    await jogador_dao.JogadorDao(db).atualizarCristais(-novosCristais);

    // Remove o item da loja
    await lojaDao.deletar(item.id!);

    bloc.add(LojaUpdated());
  } catch (e) {
    debugPrint('Erro ao comprar item: $e');
  }
}
