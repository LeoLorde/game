import 'package:game/database/seed/creature_seed.dart';
import 'package:game/database/app_database.dart';
import 'package:game/database/dao/creature_dao.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void main()
{
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
   group('AppDatabase and Creature Seed', () {
    test('Deve Carregar as Criaturas no Banco de Dado', () async {
      // Carrega criaturas no banco
      final seed = CreatureSeed();
      await seed.loadCreaturesOnDb();

      // Verifica que foram inseridas
      final creatures = await onLoad();
      expect(creatures.length, greaterThan(0));
    });

    test('Deve apagar todas as criaturas da tabela creatures', () async {
      // Carrega criaturas no banco
      final seed = CreatureSeed();
      await seed.loadCreaturesOnDb();

      // Limpa o banco
      await AppDatabase.instance.clearDatabase(["creatures"]);

      // Vericia se está vazio
      final criaturas = await onLoad();
      expect(criaturas.length, equals(0));
    });
  });
}