import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  // Instância da Classe AppDatabase (Pra ser acessado de qualquer lugar)
  // É um SINGLETON, ou seja, APENAS UM APPDATABASE EXISTE, para acessar é: AppDatabase.instance
  static final AppDatabase instance = AppDatabase._();

  static Database? _database; // A Instância do Banco de Dados

  AppDatabase._(); // Construtor da Classe

  // Vai retornar o Banco de Dados (Assíncrono)
  Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!; // Se o Banco já foi inicializado, só retorna o Banco
    }
    _database = await _initDB(
      'game.db',
    ); // Caso não esteja inicializado, inicializa o Banco
    return _database!; // Retorna o Banco
  }

  // Inicializador do Banco de Dados (Assíncrono)
  Future<Database> _initDB(String fileName) async {
    final dbPath =
        await getDatabasesPath(); // Pega o Caminho Padrão do Banco de Dados
    final path = join(
      dbPath,
      fileName,
    ); // Mostra o Caminho Completo do Banco (Ou seja, com a instância game.db)

    return await openDatabase(
      // Abre o Banco de Dados
      path,
      version: 1,
      onCreate: _onCreate,

      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  // Quando for Inicializado pela PRIMEIRA VEZ ele roda isso.
  // Caso já foi inicializado, NUNCA MAIS ISSO RODA
  Future<void> _onCreate(Database db, int version) async {
    // Cria a Tabela de Criaturas (Creatures)
    // COLOCAR TODAS AS TABELAS AQUI
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
    )
  ''');
    await db.execute('''
      CREATE TABLE collection_creature (
        player_id INTEGER,
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vida INTEGER,
        level INTEGER,
        xp REAL,
        elementos TEXT,
        raridade INTEGER,
        ataques TEXT,
        spriteFile TEXT,
        name TEXT,
        dimension INTEGER,
        FOREIGN KEY (player_id) REFERENCES jogador(id) ON DELETE CASCADE
      );
    ''');
    await db.execute('''
      CREATE TABLE deck (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        card_ids TEXT NOT NULL
      );
    ''');
  }

  Future<void> clearDatabase(List<String> tables) async {
    final db = await getDatabase();

    for (var table in tables) {
      await db.delete(table);
    }
  }

  // Fecha o Banco de Dados
  Future<void> close() async {
    if (_database != null) {
      await _database!.close(); // Fecha o Banco de Dados
      _database = null; // Zera a Instância do Banco de Dados
    }
  }
}
