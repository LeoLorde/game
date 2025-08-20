import 'package:flutter/widgets.dart';
import 'package:game/core/models/loja_model.dart';
import 'package:game/database/dao/loja_dao.dart';

Future<void> popularLoja(LojaDao lojaDao) async {
  await lojaDao.limparLoja();

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

  // Novas cartas
  final carta4 = Loja(
    tipo: 'carta',
    preco: 700,
    itemId: 4,
    spriteFile: 'assets/sprites/flarox_0.png', // Exemplo de sprite
    raridade: 3,
    quantidade: 1,
  );

  final carta5 = Loja(
    tipo: 'carta',
    preco: 900,
    itemId: 5,
    spriteFile: 'assets/sprites/azuriak_0.png', // Exemplo de sprite
    raridade: 5,
    quantidade: 1,
  );

  final carta6 = Loja(
    tipo: 'carta',
    preco: 1200,
    itemId: 6,
    spriteFile: 'assets/sprites/aeros_0.png', // Exemplo de sprite
    raridade: 5,
    quantidade: 1,
  );

  // Novos baús
  final bau1 = Loja(
    tipo: 'bau',
    preco: 1000,
    itemId: null,
    spriteFile: 'assets/sprites/baus/1/1.png',
    raridade: 0,
    quantidade: 1,
  );

  final bau2 = Loja(
    tipo: 'bau',
    preco: 2500,
    itemId: null,
    spriteFile: 'assets/sprites/baus/2/1.png',
    raridade: 0,
    quantidade: 1,
  );

  final bau3 = Loja(
    tipo: 'bau',
    preco: 5000,
    itemId: null,
    spriteFile: 'assets/sprites/baus/3/1.png',
    raridade: 0,
    quantidade: 1,
  );

  try {
    // Adicione todas as cartas e baús à loja
    await lojaDao.salvarOuAtualizar(aeros);
    await lojaDao.salvarOuAtualizar(azuriak);
    await lojaDao.salvarOuAtualizar(flarox);
    await lojaDao.salvarOuAtualizar(carta4);
    await lojaDao.salvarOuAtualizar(carta5);
    await lojaDao.salvarOuAtualizar(carta6);
    await lojaDao.salvarOuAtualizar(bau1);
    await lojaDao.salvarOuAtualizar(bau2);
    await lojaDao.salvarOuAtualizar(bau3);

    debugPrint('Loja populada com sucesso com 6 cartas e 3 baús!');
  } catch (e) {
    debugPrint('Ocorreu um erro ao popular a loja: $e');
  }
}
