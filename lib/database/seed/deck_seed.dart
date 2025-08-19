import 'package:flutter/material.dart';
import 'package:game/database/app_database.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/database/dao/deck_dao.dart';

/// Cria o deck inicial do jogador, inserindo cada criatura individualmente
Future<void> criarDeckInicialParaJogador() async {
  final db = await AppDatabase.instance.getDatabase();

  // Verifica se já existe alguma criatura no deck
  final deckExistente = await db.query('deck', limit: 1);
  if (deckExistente.isNotEmpty) {
    debugPrint("Deck do jogador já existe. Nenhuma ação necessária.");
    return;
  }

  // Pega as 3 primeiras criaturas do banco
  debugPrint("Nenhum deck encontrado. Criando deck inicial para o jogador...");
  final criaturasIniciais = await db.query('creatures', limit: 3);

  if (criaturasIniciais.length < 3) {
    debugPrint(
      "Erro: Não há criaturas suficientes no banco para criar um deck inicial.",
    );
    return;
  }

  // Converte os mapas para objetos Creature
  List<Creature> criaturas = criaturasIniciais.map((c) => Creature.fromMap(c)).toList();

  // Insere cada criatura no deck usando a função insertCreatureInDeck
  for (Creature creature in criaturas) {
    await insertCreatureInDeck(creature);
  }

  debugPrint(
    "Deck inicial criado com sucesso com as criaturas: ${criaturas.map((c) => c.name).toList()}",
  );
}
