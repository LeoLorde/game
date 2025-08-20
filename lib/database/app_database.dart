import 'package:game/database/dao/loja_dao.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// importa os seeds
import 'seed/creature_seed.dart';
import 'seed/deck_seed.dart';
import 'seed/collection_seed.dart';
import 'seed/store_seed.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await _initDB('app.db');

    return _database!;
  }

  Future<void> _populateInitialData(Database db) async {
    debugPrint("Iniciando seeds...");
    debugPrint("0/4 - Carregando Criaturas");
    await CreatureSeed().loadCreaturesOnDb();
    debugPrint("1/4 - Carregando Deck");
    await criarDeckInicialParaJogador();
    debugPrint("2/4 - Carregando Coleção");
    await CollectionSeed().loadInitialCollection(db);
    debugPrint("3/4 - Populando Loja");
    await popularLoja(LojaDao(db));
    debugPrint("4/4 - Banco Carregado");
    debugPrint("Seeds carregadas!");
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    // Criação das tabelas
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
      );
    ''');

    await db.execute('''
      CREATE TABLE jogador (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nickName TEXT NOT NULL,
        cristais INTEGER NOT NULL,
        level INTEGER NOT NULL,
        amuletos INTEGER NOT NULL,
        cartas INTEGER NOT NULL,
        xp INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE collection_creature (
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
      );
    ''');

    await db.execute('''
      CREATE TABLE deck (
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
      );
    ''');

    await db.execute('''
      CREATE TABLE loja (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        preco INTEGER NOT NULL,
        item_id INTEGER,
        spriteFile TEXT,
        raridade INTEGER,
        quantidade INTEGER DEFAULT 1
      );
    ''');
  }

  Future close() async {
    final db = await instance.getDatabase();
    db.close();
  }

  Future<void> clearDatabase(List<String> tables) async {
    final db = await getDatabase();
    for (String table in tables) {
      await db.delete(table);
    }
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('''
      CREATE TABLE loja (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        preco INTEGER NOT NULL,
        item_id INTEGER,
        spriteFile TEXT,
        raridade INTEGER,
        quantidade INTEGER DEFAULT 1
      );
    ''');
    }
  }
}
