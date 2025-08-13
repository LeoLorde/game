import 'package:game/core/models/jogador_model.dart';
import 'package:game/database/dao/jogador_dao.dart';
import 'package:game/database/app_database.dart';

class PlayerRepository {
  Future<Jogador> getPlayer() async {
    final db = await AppDatabase.instance.getDatabase();
    final dao = JogadorDao(db);

    final jogador = await dao.buscar();
    if (jogador == null) {
      throw Exception("Nenhum jogador encontrado");
    }
    return jogador;
  }

  Future<void> updateCristais(int quantidade) async {
    final db = await AppDatabase.instance.getDatabase();
    final dao = JogadorDao(db);
    await dao.atualizarCristais(quantidade);
  }

  Future<void> updateAmuletos(int quantidade) async {
    final db = await AppDatabase.instance.getDatabase();
    final dao = JogadorDao(db);
    await dao.atualizarAmuletos(quantidade);
  }

  Future<void> adicionarAmuletos(int quantidade) async {
    final db = await AppDatabase.instance.getDatabase();
    final dao = JogadorDao(db);
    final jogador = await dao.buscar(); // aguarda a consulta
    if (jogador == null) throw Exception("Nenhum jogador encontrado");
    final int amuletosatuais = jogador.amuletos;
    await dao.atualizarAmuletos(quantidade + amuletosatuais);
  }

  Future<void> updateLevel(int level) async {
    final db = await AppDatabase.instance.getDatabase();
    final dao = JogadorDao(db);
    await dao.atualizarLevel(level);
  }
}
