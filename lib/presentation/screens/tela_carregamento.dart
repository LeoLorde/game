import 'package:flutter/material.dart';
import 'package:game/database/app_database.dart';
import 'package:game/core/models/jogador_model.dart';
import 'package:game/database/dao/jogador_dao.dart';
import 'package:game/presentation/screens/tela_cadastro.dart';
import 'package:game/presentation/screens/tela_principal.dart';

class TelaCarregamento extends StatelessWidget {
  const TelaCarregamento({super.key});

  Future<Widget> _verificarJogador() async {
    final db = await AppDatabase.instance.getDatabase();
    final dao = JogadorDao(db);
    final jogador = await dao.buscar();

    if (jogador == null) {
      return TelaCadastroJogador(); // Crie essa tela para o cadastro
    } else {
      return TelaPrincipal(jogador: jogador); // Já entra no jogo
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _verificarJogador(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const Scaffold(
            body: Center(child: Text("Erro ao iniciar o app")),
          );
        }
      },
    );
  }
}
