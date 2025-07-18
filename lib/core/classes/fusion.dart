import 'dart:math';

import 'package:game/core/enums/elemento_enum.dart';
import '../../core/models/creature_model.dart';
import 'package:game/database/dao/creature_dao.dart';
import 'package:game/database/seed/creature_seed.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'dart:math';

class Fusion {
  Creature criatura1 = CreatureSeed.all_creatures[0];//emula uma criatura que o jogador vai fundir
  Creature criatura2 = CreatureSeed.all_creatures[1];//emula uma criatura que o jogador vai fundir

  int get nv_criatura1 => criatura1.level;//pega o nível da primeira criatura
  int get nv_criatura2 => criatura2.level;//pega o nível da segunda criatura
  int get nivelMedio => ((nv_criatura1 + nv_criatura2) / 2).round();//faz a media de níveis
  Raridade get raridade_criatura1 => criatura1.raridade;
  Raridade get raridade_criatura2 => criatura2.raridade;

  List<Elemento> get ele_criatura1 => criatura1.elementos;//pega os elementos da primeira criatura
  List<Elemento> get ele_criatura2 => criatura2.elementos;//pega os elementos da segunda criatura

  List<Elemento> get elementosFundidos {//junta os elementos da primeira e da segunda criatura em uma lista só
    return {...ele_criatura1, ...ele_criatura2}.toList();//transforma em lista mesmo
  }
    
    //Fazer a verificação de raridade (se subiu de raridade aleatoriamente)
    final Random _random = Random();

  /// Calcula a chance com base em um valor entre 0 e 1000
  /// Cada ponto representa 0.1% de chance
  double calcularChance(int valor) {
    return (valor * 0.1).clamp(0.0, 100.0); // garante entre 0% e 100%
  }

  /// Retorna true se o evento acontecer com base na chance
  bool eventoAcontece(int valor) {
    double chance = calcularChance(valor);
    double sorteio = _random.nextDouble() * 100; // número entre 0.0 e 100.0
    return sorteio <= chance;
  }

    //Fazer a média de nível considerando a raridade

    //Caso a raridade for aumentada o nível médio cai pela metade (nível médio * 0,5)

    //Armazenar os elementos das 2 cartas selecionadas dentro de uma lista

    //Fazer a verificação se essa lista de elementos criados se encontra em uma carta, senão, seleciona a mais próxima

    //Cria a nova carta gerada baseada nos elementos e no nível já recebidos acima

}



