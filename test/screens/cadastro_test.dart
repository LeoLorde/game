import 'package:flutter/material.dart';
import 'package:game/core/models/jogador_model.dart';
import 'package:game/database/app_database.dart';
import 'package:game/database/dao/jogador_dao.dart';
import 'package:game/presentation/screens/tela_principal.dart';
import 'package:game/application/managers/player_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/database/app_database.dart';
import 'package:game/database/dao/jogador_dao.dart';
import 'package:game/application/managers/player_manager.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  TestWidgetsFlutterBinding.ensureInitialized();

  group('Teste de criação de jogador', () {
    test('Criação e busca de jogador', () async {
      final db = await AppDatabase.instance.getDatabase();
      final dao = JogadorDao(db);

      await CreatePlayer("Hello World");

      expect(player_instance, isNotNull);
      print("--------------------");
      print(player_instance.id);
      print("--------------------");
      final id = player_instance?.id ?? -1;

      print("BUSCANDO COM ID");
      final jogadorSalvo = await dao.buscarByID(id);
      print("SE NÃO SALVOU VTNC");

      expect(jogadorSalvo, isNotNull);
      expect(jogadorSalvo!.nickName, "Hello World");
    });
  });
}