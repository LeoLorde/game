import 'package:flutter/material.dart';

class TelaLoja extends StatefulWidget {
  const TelaLoja({super.key});
  @override
  State<TelaLoja> createState() => _TelaLojaState();
}

class _TelaLojaState extends State<TelaLoja> {
  Widget buildCard(String imageUrl, String preco, Color cor) {
    return Container(
      width: 120,
      height: 170,
      child: Card(
        color: cor,
        child: Column(
          children: [
            Expanded(child: Image.network(imageUrl, fit: BoxFit.contain)),
            const SizedBox(height: 4),
            Text(
              preco,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSimpleCard(String imageUrl, Color cor) {
    return SizedBox(
      width: 120,
      height: 170,
      child: Card(
        color: cor,
        child: Image.network(imageUrl, fit: BoxFit.contain),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const imageUrl =
        'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/full/151.png';
    const iconUrl = 'https://cdn-icons-png.flaticon.com/512/9317/9317142.png';
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
                  buildCard(imageUrl, '2.000', cores[col % cores.length]),
                  buildCard(imageUrl, '2.000', cores[(col + 1) % cores.length]),
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
            children: [for (var cor in cores) buildSimpleCard(iconUrl, cor)],
          ),
        ],
      ),
    );
  }
}
