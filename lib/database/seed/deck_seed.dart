import 'package:game/database/app_database.dart';
import 'package:game/core/models/deck_model.dart';
import 'package:sqflite/sqflite.dart';

/// Verifica se o jogador tem um deck; se não tiver, cria um deck inicial.
Future<void> criarDeckInicialParaJogador() async {
  final db = await AppDatabase.instance.getDatabase();

  // 1. Verifica se já existe algum deck na tabela
  final decksExistentes = await db.query('deck', limit: 1);
  if (decksExistentes.isNotEmpty) {
    print("Deck do jogador já existe. Nenhuma ação necessária.");
    return; // Sai da função se o deck já foi criado
  }

  // 2. Se não existe, pega as 3 primeiras criaturas do banco
  print("Nenhum deck encontrado. Criando deck inicial para o jogador...");
  final criaturasIniciais = await db.query('creatures', limit: 3);

  if (criaturasIniciais.length < 3) {
    print(
      "Erro: Não há criaturas suficientes no banco para criar um deck inicial.",
    );
    return;
  }

  // 3. Pega os IDs das criaturas
  final idsDasCriaturas = criaturasIniciais.map((c) => c['id'] as int).toList();

  // 4. Cria o modelo do novo deck
  final novoDeck = DeckModel(
    name: 'Meu Primeiro Deck',
    cardIds: idsDasCriaturas,
    playerID: 1, // ID do jogador, se você tiver um
  );

  // 5. Salva o novo deck no banco de dados
  await db.insert('deck', novoDeck.toMap());
  print(
    "Deck inicial criado com sucesso com as criaturas de IDs: $idsDasCriaturas",
  );
}
