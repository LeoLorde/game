import 'package:flutter/material.dart';
import 'package:game/database/app_database.dart';
import 'package:game/core/models/deck_model.dart';
import 'package:sqflite/sqflite.dart';

/// Verifica se o jogador tem um deck; se não tiver, cria um deck inicial.
Future<void> criarDeckInicialParaJogador() async {
  final db = await AppDatabase.instance.getDatabase();

  // Verifica se já existe algum deck na tabela
  final decksExistentes = await db.query('deck', limit: 1);
  if (decksExistentes.isNotEmpty) {
    debugPrint("Deck do jogador já existe. Nenhuma ação necessária.");
    return; // Sai da função se o deck já foi criado
  }

  // Se não existe, pega as 3 primeiras criaturas do banco
  debugPrint("Nenhum deck encontrado. Criando deck inicial para o jogador...");
  final criaturasIniciais = await db.query('creatures', limit: 3);

  if (criaturasIniciais.length < 3) {
    debugPrint(
      "Erro: Não há criaturas suficientes no banco para criar um deck inicial.",
    );
    return;
  }

  // Pega os IDs das criaturas
  final idsDasCriaturas = criaturasIniciais.map((c) => c['id'] as int).toList();

  // Cria o modelo do novo deck
  final novoDeck = DeckModel(
    name: 'Meu Primeiro Deck',
    cardIds: idsDasCriaturas,
    playerID: 1, // ID do jogador, se você tiver um
  );

  // Salva o novo deck no banco de dados
  await db.insert('deck', novoDeck.toMap());
  debugPrint(
    "Deck inicial criado com sucesso com as criaturas de IDs: $idsDasCriaturas",
  );
}
