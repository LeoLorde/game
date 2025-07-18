import 'package:flutter/material.dart';
import 'package:game/core/models/jogador_model.dart';
import 'package:game/database/app_database.dart';
import 'package:game/database/dao/jogador_dao.dart';
import 'package:game/presentation/screens/tela_principal.dart';
import 'package:game/application/managers/player_manager.dart';

class TelaCadastroJogador extends StatefulWidget {
  @override
  _TelaCadastroJogadorState createState() => _TelaCadastroJogadorState();
}

class _TelaCadastroJogadorState extends State<TelaCadastroJogador> {
  final _controller = TextEditingController();

  Future<void> _cadastrarJogador() async {
    final nome = _controller.text.trim();
    if (nome.isEmpty) return;

    final db = await AppDatabase.instance.getDatabase();
    final dao = JogadorDao(db);

    await CreatePlayer(nome);

    // Buscar o jogador salvo com ID preenchido
    final jogadorSalvo = await dao.buscarByID(player_instance!.id ?? 0);
    if (jogadorSalvo != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TelaPrincipal(jogador: jogadorSalvo)),
      );
    } else {
      // Caso algo dê errado, mostrar erro
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(jogadorSalvo!.nickName)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4732),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Digite seu Nickname:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Nickname',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _cadastrarJogador,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('JOGAR!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
