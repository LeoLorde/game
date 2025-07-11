import 'package:flutter/material.dart';
import 'package:game/core/enums/dimension_enum.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:game/core/models/jogador_model.dart';
import 'package:game/presentation/screens/tela_colecao.dart';
import 'package:game/presentation/screens/tela_loja.dart';
import 'package:game/presentation/screens/tela_inicial.dart';

class TelaPrincipal extends StatefulWidget {
  final Jogador jogador;

  const TelaPrincipal({Key? key, required this.jogador}) : super(key: key);

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
    final jogador = widget.jogador; // 👈 acesso correto ao jogador

    return Scaffold(
      appBar: buildAppBar(
        jogador.nickName,
        jogador.cristais,
        jogador.level,
        jogador.amuletos,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _paginaAtual = index),
        children: [
          ColecaoScreen(
            criaturas: [
              Creature(
                1500,
                10,
                200.0,
                [Elemento.fogo],
                Raridade.lendaria,
                [
                  Attack("Chama Infernal", 120, [Elemento.fogo]),
                ],
                "dragao.png",
                "Dragão Flamejante",
                DimensionEnum.cu,
              ),
              Creature(
                1000,
                8,
                150.0,
                [Elemento.terra],
                Raridade.rara,
                [
                  Attack("Soco de Pedra", 90, [Elemento.terra]),
                ],
                "golem.png",
                "Golem de Pedra",
                DimensionEnum.cu,
              ),
            ],
          ),
          TelaInicial(),
          TelaLoja(),
        ],
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
