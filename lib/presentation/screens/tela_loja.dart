import 'package:flutter/material.dart';

class TelaLoja extends StatefulWidget {
  const TelaLoja({super.key});
  @override
  State<TelaLoja> createState() => _TelaLojaState();
}

class _TelaLojaState extends State<TelaLoja> with TickerProviderStateMixin {
  void _mostrarAnimacaoBau() {
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

  Widget buildCard(String precoCarta, Color cor) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 54, 145, 99),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              title: const Text("CONFIRMAR COMPRA"),
              content: Text(
                "DESEJA COMPRAR ESTA CARTA POR $precoCarta CRISTAIS?",
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.black, width: 2),
                        ),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("CANCELAR"),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.black, width: 2),
                        ),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // lógica pra realizar a compra da carta
                        return Navigator.of(context).pop();
                      },
                      child: const Text("COMPRAR"),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
      child: Container(
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
                  'assets/sprites/aeros_0.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                precoCarta,
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

  Widget buildBauCard(String precoBau, Color cor) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 54, 145, 99),
              title: const Text("CONFIRMAR COMPRA"),
              content: Text("DESEJA COMPRAR ESTE BAÚ POR $precoBau CRISTAIS?"),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.black, width: 2),
                        ),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("CANCELAR"),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.black, width: 2),
                        ),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _mostrarAnimacaoBau();
                      },
                      child: const Text("COMPRAR"),
                    ),
                  ],
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
                  'assets/sprites/baus/3/1.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                precoBau,
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
          Center(
            child: Image.network(
              bannerUrl,
              height: 200,
              width: 200,
              color: Colors.red,
            ),
          ),
          Center(
            child: Text(
              'NOVAS CARTAS EM 18H E 21MIN',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (col) {
              return Column(
                children: [
                  buildCard('5.000', cores[col % cores.length]),
                  buildCard('5.000', cores[(col + 1) % cores.length]),
                ],
              );
            }),
          ),
          const SizedBox(height: 24),
          Center(
            child: Image.network(
              bannerUrl,
              height: 200,
              width: 200,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [for (var cor in cores) buildBauCard('2.000', cor)],
          ),
        ],
      ),
    );
  }
}
