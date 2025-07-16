// Apenas para salvar a instância do player

import 'package:game/core/models/jogador_model.dart';
import 'package:game/database/dao/jogador_dao.dart';
import 'package:game/database/app_database.dart';

Jogador? player_instance = Jogador(nickName: "", cristais: 0, level: 0, amuletos: 0, cartas: 0);


Future<void> LoadNewPlayer(int id) async {
  final db = await AppDatabase.instance.getDatabase();
  JogadorDao dao = JogadorDao(await AppDatabase.instance.getDatabase());
  player_instance = await dao.buscarByID(id);
}