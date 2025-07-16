import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/core/enums/dimension_enum.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/database/app_database.dart';

import 'package:sqflite/sqflite.dart';

import 'package:game/database/dao/creature_dao.dart'; // onde estão insertCreature() e onLoad()

void main() {
  // Inicializa o FFI (necessário para testes locais com SQLite)
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('LoadCreatureTest', () {
    setUp(() async {
      // Garante que o banco comece zerado antes de cada teste
      final db = await AppDatabase.instance.getDatabase();
      await db.execute('DROP TABLE IF EXISTS creatures');
      await db.execute('''
        CREATE TABLE creatures (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          vida INTEGER,
          level INTEGER,
          xp REAL,
          elementos TEXT,
          raridade INTEGER,
          ataques TEXT,
          spriteFile TEXT,
          name TEXT,
          dimension INTEGER
        )
      ''');
    });

    test('Deve inserir e carregar corretamente uma criatura do banco', () async {
      // Cria uma criatura pra inserir no Banco
      final creature = Creature(
        100,
        5,
        42.5,
        [Elemento.fogo, Elemento.agua],
        Raridade.epica,
        [
          Attack('Chama Mística', 20, [Elemento.fogo]),
          Attack('Jato de Água', 15, [Elemento.agua]),
        ],
        'fire_sprite.png',
        "nome",
        DimensionEnum.cu
      );

      // Insere e carrega
      await insertCreature(creature, 'creatures');
      final creatures = await onLoad();

      // Verificações 
      expect(creatures.length, 1);
      final loaded = creatures[0];

      expect(loaded.vida, 100, reason: "Vida Incorreta");
      expect(loaded.level, 5, reason: "Level Incorreto");
      expect(loaded.xp, 42.5, reason: "XP Incorreto");
      expect(loaded.elementos, [Elemento.fogo, Elemento.agua], reason: "Elementos Incorretos");
      expect(loaded.raridade, Raridade.epica, reason: "Raridade Incorreta");
      expect(loaded.ataques.length, 2, reason: "Quantidade de Ataques Incorreta");
      expect(loaded.ataques[0].name, 'Chama Mística', reason: "Ataque 1 (name) Incorreto");
      expect(loaded.ataques[1].base_damage, 15, reason: "Ataque 2 (base_damage) Incorreto");
      expect(loaded.spriteFile, 'fire_sprite.png', reason: "SpriteFile Incorreto");
      expect(loaded.name, 'nome', reason: "Nome Incorreto");
      expect(loaded.dimension, DimensionEnum.cu, reason: "Dimensão Incorreta");
    });
  });
}
