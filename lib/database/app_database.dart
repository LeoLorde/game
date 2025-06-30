import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
   // Instância da Classe AppDatabase (Pra ser acessado de qualquer lugar)
   // É um SINGLETON, ou seja, APENAS UM APPDATABASE EXISTE, para acessar é: AppDatabase.instance
  static final AppDatabase instance = AppDatabase._();

  static Database? _database; // A Instância do Banco de Dados 

  AppDatabase._(); // Construtor da Classe 

  // Vai retornar o Banco de Dados (Assíncrono)
  Future<Database> get database async { 
    if (_database != null) 
    {
      return _database!; // Se o Banco já foi inicializado, só retorna o Banco
    } 
    _database = await _initDB('game.db'); // Caso não esteja inicializado, inicializa o Banco
    return _database!; // Retorna o Banco
  }

  // Inicializador do Banco de Dados (Assíncrono)
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath(); // Pega o Caminho Padrão do Banco de Dados
    final path = join(dbPath, fileName); // Mostra o Caminho Completo do Banco (Ou seja, com a instância game.db)

    return await openDatabase( // Abre o Banco de Dados
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  // Quando for Inicializado pela PRIMEIRA VEZ ele roda isso. 
  // Caso já foi inicializado, NUNCA MAIS ISSO RODA
  Future<void> _onCreate(Database db, int version) async { 
    // TODAS AS TABELAS DEVEM ESTAR AQUI
    throw UnimplementedError(); // (Erro de Não Implementado Ainda)
  }

  // Fecha o Banco de Dados
  Future<void> close() async { 
    final db = await database;
    db.close();
  }
}
