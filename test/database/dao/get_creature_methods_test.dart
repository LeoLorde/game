import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
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

  group('Get Creature Methods Test', () {
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
          name TEXT
        )
      ''');
    });
    // Verifica se Encontra a Criatura Corretamente
    test("getCreatureByName Test 1 - Single Creature", () async {
      final Creature criatura = Creature(
        30,
        1,
        0,
        [Elemento.agua, Elemento.ar],
        Raridade.epica,
        [Attack("Ataque 1", 5, [Elemento.ar])],
        "Null",
        "Criatura Teste");

        await insertCreature(criatura); // Insere para Teste
        final Creature? criatura_do_banco = await getCreatureByName("Criatura Teste"); // Pega a Criatura
        
        expect(criatura_do_banco, isNotNull,
          reason: "Criatura Não Encontrada"
        ); // Verifica se NÃO É NULO
        expect(criatura_do_banco!.name, equals("Criatura Teste"),
          reason: "Criatura com Nome Incorreto"); // Verifica se o Nome Está Correto (o ! garante que o Creature NÃO É NULO)
        expect(criatura_do_banco.raridade, equals(Raridade.epica),
          reason: "Criatura com Dados Incorretos"); // Verifica a Raridade (Por Precaução)
      });

      test("getCreatureByName Test 2 - Various Creatures", () async {
        final Creature criatura = Creature( // Cria a Criatura
          30,
          1,
          0,
          [Elemento.agua, Elemento.ar],
          Raridade.epica,
          [Attack("Ataque 1", 5, [Elemento.ar])],
          "Null",
          "Criatura Teste");

        final Creature criatura_2 = criatura;
        criatura_2.level = 15; // Cria uma segunda criatura com nível diferente

        await insertCreature(criatura);
        await insertCreature(criatura_2); // Insere Ambas (na ordem correta para o teste)
        final Creature? criatura_do_banco = await getCreatureByName("Criatura Teste"); // Pega a Criatura
        
        expect(criatura_do_banco, isNotNull,
          reason: "Criatura Não Encontrada"); // Verifica se não é nula
        expect(criatura_do_banco!.level, equals(criatura.level),
          reason: "Criatura INCORRETA Encontrada"); // Verifica se o Level está idêntico à criatura 1
      });
  });
}