import 'package:flutter/material.dart';
import 'package:game/core/enums/dimension_enum.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:game/core/models/jogador_model.dart';
import 'package:game/presentation/screens/collection_screen/tela_colecao.dart';
import 'package:game/presentation/screens/store_screen/tela_loja.dart';
import 'package:game/presentation/screens/init_page/tela_inicial.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:game/application/audio/audio_manager.dart';

class TelaPrincipal extends StatefulWidget {
  final Jogador jogador;

  const TelaPrincipal({Key? key, required this.jogador}) : super(key: key);

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  void initState() {
    super.initState();
    AudioManager.instance.init();
    AudioManager.instance.playBgm('sounds/som/bg2.mp3');
  }

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
      backgroundColor: const Color(0xFF2C5282),
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
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'NÍVEL: $level',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'PressStart2P',
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
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'PressStart2P',
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'AMULETOS: $amuletos',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'PressStart2P',
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
    final jogador = widget.jogador;

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
        children: [ColecaoScreen(), TelaInicial(), TelaLoja()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        onTap: _mudarPagina,
        backgroundColor: const Color(0xFF2C5282),
        selectedLabelStyle: const TextStyle(
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
