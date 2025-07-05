import 'package:sqflite/sqflite.dart';
import '../../core/models/jogador_model.dart';

class JogadorDao {
  final Database db;

  JogadorDao(this.db);

  Future<void> salvarOuAtualizar(Jogador jogador) async {
    final existente = await buscar();

    if (existente == null) {
      await db.insert('jogadores', jogador.toMap());
    } else {
      await db.update(
        'jogadores',
        jogador.toMap(),
        where: 'id = ?',
        whereArgs: [1],
      );
    }
  }

  Future<Jogador?> buscar() async {
    final maps = await db.query('jogadores', where: 'id = ?', whereArgs: [1]);

    if (maps.isNotEmpty) {
      return Jogador.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> deletar() async {
    await db.delete('jogadores', where: 'id = ?', whereArgs: [1]);
  }
}
