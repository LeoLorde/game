import 'package:sqflite/sqflite.dart';
import '../../core/models/jogador_model.dart';
/*
final db = await AppDatabase.instance.getDatabase();
*/
class JogadorDao {
  final Database db;

  JogadorDao(this.db);

  Future<void> salvarOuAtualizar(Jogador jogador) async {
    final existente = await buscar();

    if (existente == null) {
      await db.insert('jogador', jogador.toMap());
    } else {
      await db.update(
        'jogador',
        jogador.toMap(),
        where: 'id = ?',
        whereArgs: [existente.id],
      );
    }
  }

  Future<Jogador?> buscar() async {
    final maps = await db.query('jogador', limit: 1);

    if (maps.isNotEmpty) {
      return Jogador.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Jogador?> buscarByID(int id) async{
    final maps = await db.query('jogador', where: 'id=?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Jogador.fromMap(maps.first);
    } else {
      return null;
    }
  }


  Future<void> deletar() async {
    await db.delete('jogador');
  }

  // Verifiacr Cartas do Jogador

  Future<int> contarCartasDoJogador() async {
    final result = await db.rawQuery('SELECT COUNT(*) FROM collection_cards');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Atualizar informações do jogador

  //Atualizar Cristais
  Future<void> atualizarCristais(int quantidade) async {
    final jogador = await buscar();

    if (jogador != null) {
      jogador.cristais += quantidade;
      await salvarOuAtualizar(jogador);
    }
  }

  // Exemplo Cristais
  // await jogadorDao.atualizarCristais(100); // Adiciona 100 cristais
  // await jogadorDao.atualizarCristais(-50); // Remove 50 cristais

  //Atualizar Amuletos
  Future<void> atualizarAmuletos(int quantidade) async {
    final jogador = await buscar();

    if (jogador != null) {
      jogador.amuletos += quantidade;
      await salvarOuAtualizar(jogador);
    }
  }

  // Exemplo Amuletos
  // await jogadorDao.atualizarAmuletos(5); // Adiciona 5 amuletos
  // await jogadorDao.atualizarAmuletos(-2); // Remove 2 am

  //Atualizar Level
  Future<void> atualizarLevel(int novoLevel) async {
    final jogador = await buscar();

    if (jogador != null) {
      jogador.level = novoLevel;
      await salvarOuAtualizar(jogador);
    }
  }

  // Exemplo Level
  // await jogadorDao.atualizarLevel(10); // Define o level do jogador para 10

  Future<void> adicionarXpPorVitoria(int xpGanho) async {
    final jogador = await buscar();

    if (jogador != null) {
      jogador.xp = (jogador.xp ?? 0) + xpGanho;

      await salvarOuAtualizar(jogador);
    }
  }
  // Exemplo XP
  // await jogadorDao.adicionarXpPorVitoria(50); // Adiciona 50 XP ao jogador

  // Função que define quanto XP é necessário para cada nível
  int xpNecessarioParaNivel(int nivel) {
    // Exemplo: fórmula exponencial simples
    return 10 * nivel * 15;
  }
}
