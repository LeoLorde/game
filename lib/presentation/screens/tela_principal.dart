import 'package:flutter/material.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/presentation/screens/tela_colecao.dart';
import 'package:game/presentation/screens/tela_loja.dart';
import 'package:game/presentation/screens/tela_inicial.dart';

class TelaPrincipal extends StatefulWidget {
  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final PageController _pageController = PageController(initialPage: 1);
  int _paginaAtual = 1;

  void _mudarPagina(int index) {
    setState(() => _paginaAtual = index);
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  PreferredSizeWidget buildAppBar(
    String nickName,
    int cristais,
    int level,
    int amuletos,
  ) {
    return AppBar(
      toolbarHeight: 80,
      centerTitle: false,
      backgroundColor: const Color(0xFF1B4732),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                nickName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'PressStart2P',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'NÍVEL: $level',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'PressStart2P',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'CRISTAIS: $cristais',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'PressStart2P',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'AMULETOS: $amuletos',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'PressStart2P',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('YANG_XUXU', 7688, 24, 2109),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _paginaAtual = index),
        children: const [TelaLoja(), TelaInicial(), TelaLoja()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        onTap: _mudarPagina,
        backgroundColor: const Color(0xFF1B4732),
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: SizedBox(height: 0), label: "COLEÇÃO"),
          BottomNavigationBarItem(icon: SizedBox(height: 0), label: "INÍCIO"),
          BottomNavigationBarItem(icon: SizedBox(height: 0), label: "LOJA"),
        ],
      ),
    );
  }
}
