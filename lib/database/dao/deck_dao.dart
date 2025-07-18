import 'package:flutter/foundation.dart';
import 'package:game/core/models/deck_model.dart';
import 'package:game/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

// Função para inserir ou atualizar um deck no banco de dados
Future<void> upsertDeck(DeckModel deck) async {
  final db = await AppDatabase.instance.getDatabase();

  final maps = await db.query('deck');
  if (maps.isEmpty) {
    await db.insert('deck', deck.toMap());
  } else {
    final id = maps.first['id'] as int;
    await db.update('deck', deck.toMap(), where: 'id = ?', whereArgs: [id]);
  }
}

// Função para adicionar cartas ao deck
Future<void> addCardsToSingleDeck(List<int> newCards) async {
  final db = await AppDatabase.instance.getDatabase();

  final maps = await db.query('deck');
  if (maps.isEmpty) throw Exception('Deck ainda não foi criado.');

  final deck = DeckModel.fromMap(maps.first);

  if (deck.cardIds.length + newCards.length > 3) {
    throw Exception('O deck pode ter no máximo 3 cartas.');
  }

  deck.cardIds.addAll(newCards);
  await db.update('deck', deck.toMap(), where: 'id = ?', whereArgs: [deck.id]);
}

// Função para remover carta do deck
Future<void> removeCardFromSingleDeck(int cardId) async {
  final db = await AppDatabase.instance.getDatabase();

  final maps = await db.query('deck');
  if (maps.isEmpty) throw Exception('Deck ainda não foi criado.');

  final deck = DeckModel.fromMap(maps.first);

  deck.cardIds.remove(cardId);
  await db.update('deck', deck.toMap(), where: 'id = ?', whereArgs: [deck.id]);
}

// Exemplo
// void testarDeckUnico() async {
//   final db = await AppDatabase.instance.getDatabase();

//   Cria ou atualiza o único deck com nome e nenhuma carta
//   final meuDeck = DeckModel(name: 'Deck Único', cardIds: []);
//   await upsertDeck(meuDeck);

//   Adiciona 2 cartas
//   await addCardsToSingleDeck([1, 2]);

//   Adiciona a terceira carta
//   await addCardsToSingleDeck([3]);

//   Tenta remover a carta 2
//   await removeCardFromSingleDeck(2);

//   Carrega o deck atualizado
//   final resultado = await db.query('deck');
//   final deckFinal = DeckModel.fromMap(resultado.first);

//   debugPrint('Deck final: ${deckFinal.name} -> Cartas: ${deckFinal.cardIds}');
// }
