import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:game/database/seed/collection_seed.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._();
  static Database? _database;

  AppDatabase._();

  Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('game.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
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
        name TEXT NOT NULL,
        card_ids TEXT NOT NULL
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
        quantidade INTEGER DEFAULT 1,     
        FOREIGN KEY(item_id) REFERENCES creatures(id)
      );
    ''');

    // Inserir criaturas iniciais
    try {
      final seed = CollectionSeed();
      await seed.loadInitialCollection(db);
      print("[AppDatabase] Coleção inicial carregada com sucesso!");
    } catch (e, stack) {
      print("[AppDatabase] Erro ao carregar coleção inicial: $e");
      print(stack);
    }
  }

  Future<void> clearDatabase(List<String> tables) async {
    final db = await getDatabase();
    for (var table in tables) {
      await db.delete(table);
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
