import 'package:flutter/widgets.dart';
import 'package:game/core/models/loja_model.dart';
import 'package:game/database/dao/loja_dao.dart';

Future<void> popularLojaComCartas(LojaDao lojaDao) async {
  final aeros = Loja(
    tipo: 'carta',
    preco: 200,
    itemId: 1,
    spriteFile: 'assets/sprites/aeros_0.png',
    raridade: 4,
    quantidade: 1,
  );

  final azuriak = Loja(
    tipo: 'carta',
    preco: 500,
    itemId: 2,
    spriteFile: 'assets/sprites/azuriak_0.png',
    raridade: 1,
    quantidade: 1,
  );

  final flarox = Loja(
    tipo: 'carta',
    preco: 300,
    itemId: 3,
    spriteFile: 'assets/sprites/flarox_0.png',
    raridade: 2,
    quantidade: 1,
  );

  try {
    final idInserido_1 = await lojaDao.salvarOuAtualizar(azuriak);
    final idInserido_2 = await lojaDao.salvarOuAtualizar(aeros);
    final idInserido_3 = await lojaDao.salvarOuAtualizar(flarox);
    debugPrint(
      'Carta ID da Loja: $idInserido_3\n $idInserido_2\n $idInserido_1',
    );
  } catch (e) {
    debugPrint('Ocorreu um erro ao adicionar as cartas: $e');
  }
}
