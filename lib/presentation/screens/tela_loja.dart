import 'package:flutter/material.dart';
import 'package:game/database/dao/loja_dao.dart';
import 'package:game/presentation/screens/tela_principal.dart';
import 'package:game/application/audio/audio_manager.dart';
import 'package:game/database/dao/loja_dao.dart';
import 'package:game/core/models/loja_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TelaLoja extends StatefulWidget {
  const TelaLoja({super.key});
  @override
  State<TelaLoja> createState() => _TelaLojaState();
}

class _TelaLojaState extends State<TelaLoja> with TickerProviderStateMixin {
  LojaDao? lojaDao;
  List<Loja> itens = [];

  @override
  void initState() {
    super.initState();
    _initDb();
  }

  Future<void> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'meujogo.db');
    final db = await openDatabase(path);
    lojaDao = LojaDao(db);
    await _carregarItens();
  }

  Future<void> _carregarItens() async {
    if (lojaDao != null) {
      final lista = await lojaDao!.buscarTodos();
      setState(() {
        itens = lista;
      });
    }
  }

  void somAbrirBau() {
    AudioManager.instance.playSfx('sounds/som/bau_abrindo.mp3');
  }

  void _mostrarAnimacaoBau() {
    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final controller = AnimationController(
              duration: const Duration(milliseconds: 600),
              vsync: this,
            );
            final animation = IntTween(begin: 1, end: 7).animate(controller);

            controller.forward();

            Future.delayed(const Duration(milliseconds: 800), () {
              if (Navigator.of(dialogContext).canPop()) {
                Navigator.of(dialogContext).pop();
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
                      'assets/sprites/baus/3/$frame.png',
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

  Future<void> _comprarItem(int id, String tipo) async {
    try {
      await lojaDao?.comprarItem(id);
      if (tipo == 'bau') {
        _mostrarAnimacaoBau();
        somAbrirBau();
      }
      await _carregarItens();
    } catch (e) {
      ScaffoldMessenger.of(
        this.context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget buildItemCard(Loja item, Color cor) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
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
                  onPressed: () {
                    Navigator.of(context).pop();
                    _comprarItem(item.id!, item.tipo);
                  },
                  child: const Text("COMPRAR"),
                ),
              ],
            );
          },
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

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 94, 67),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Center(child: Image.network(bannerUrl, height: 200, width: 200)),
          const SizedBox(height: 16),
          if (itens.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: List.generate(itens.length, (index) {
                final item = itens[index];
                return buildItemCard(item, cores[index % cores.length]);
              }),
            ),
        ],
      ),
    );
  }
}
