import 'package:game/core/models/jogador_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/models/loja_model.dart';

class LojaDao {
  final Database db;

  LojaDao(this.db);

  /// Salva ou atualiza um item da loja
  Future<int> salvarOuAtualizar(Loja item) async {
    if (item.id == null) {
      return await db.insert('loja', item.toMap());
    } else {
      return await db.update(
        'loja',
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      );
    }
  }

  //  Busca todos os itens disponíveis na loja
  Future<List<Loja>> buscarTodos() async {
    final maps = await db.query('loja');
    return maps.map((map) => Loja.fromMap(map)).toList();
  }

  /// Busca um item específico por ID
  Future<Loja?> buscarPorId(int id) async {
    final maps = await db.query('loja', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Loja.fromMap(maps.first);
    }
    return null;
  }

  /// Remove um item da loja
  Future<int> deletar(int id) async {
    return await db.delete('loja', where: 'id = ?', whereArgs: [id]);
  }

  /// Limpa todos os itens da loja
  Future<void> limparLoja() async {
    await db.delete('loja');
  }

  // Comprar um item da loja
  /// Compra um item da loja pelo ID
  Future<Loja?> comprarItem(int lojaItemId) async {
    return await db.transaction((txn) async {
      // Buscar o jogador
      final jogadorData = await txn.query('jogador', limit: 1);
      if (jogadorData.isEmpty) {
        throw Exception("Nenhum jogador encontrado.");
      }
      final jogador = Jogador.fromMap(jogadorData.first);

      // Buscar o item da loja
      final itemData = await txn.query(
        'loja',
        where: 'id = ?',
        whereArgs: [lojaItemId],
      );
      if (itemData.isEmpty) {
        throw Exception("Item não encontrado na loja.");
      }
      final lojaItem = Loja.fromMap(itemData.first);

      // Verificar cristais suficientes
      if (jogador.cristais < lojaItem.preco) {
        throw Exception("Cristais insuficientes.");
      }

      // Diminuir cristais do jogador
      jogador.cristais -= lojaItem.preco;
      await txn.update(
        'jogador',
        jogador.toMap(),
        where: 'id = ?',
        whereArgs: [jogador.id],
      );

      // Remover item da loja
      await txn.delete('loja', where: 'id = ?', whereArgs: [lojaItemId]);

      // Adicionar item na coleção do jogador
      // Se for uma carta, copia dados da tabela creatures
      if (lojaItem.tipo == 'carta' && lojaItem.itemId != null) {
        final creatureData = await txn.query(
          'creatures',
          where: 'id = ?',
          whereArgs: [lojaItem.itemId],
        );
        if (creatureData.isEmpty) {
          throw Exception("Carta não encontrada na tabela creatures.");
        }
        final creature = creatureData.first;

        await txn.insert('collection_creature', creature);
      }

      // Adicionar para 'bau'

      return lojaItem;

      //       final lojaDao = LojaDao(db);
      // try {
      //   final sucesso = await lojaDao.comprarItem(5); ID do item na loja
      //   if (sucesso) {
      //     print("Compra realizada com sucesso!");
      //   }
      // } catch (e) {
      //   print("Erro na compra: $e");
      // }
    });
  }
}
