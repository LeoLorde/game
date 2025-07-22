import 'dart:math';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import '../../core/models/creature_model.dart';
import 'package:game/database/seed/creature_seed.dart';

class Fusion {
  Creature criatura1 = CreatureSeed.all_creatures[0];
  Creature criatura2 = CreatureSeed.all_creatures[1];
  final Random _random = Random();

  List<Elemento> get elementosFundidos =>
      {...?criatura1.elementos, ...?criatura2.elementos}.toList();

  // Cálculo do custo com base na raridade
  double calcularCustoFusao(Creature criatura) {
    int nivel = criatura.level;
    switch (criatura.raridade) {
      case Raridade.combatente:
        return nivel.toDouble();
      case Raridade.mistico:
        return nivel * 1.5;
      case Raridade.heroi:
        return nivel * 2.0;
      case Raridade.semideus:
        return nivel * 3.0;
      case Raridade.deus:
        return nivel * 5.0;
      default:
        return 0.0;
    }
  }

  double get custoTotal =>
      calcularCustoFusao(criatura1) + calcularCustoFusao(criatura2);

  double chancePorRaridade(Raridade raridade) {
    switch (raridade) {
      case Raridade.combatente:
        return 60.0;
      case Raridade.mistico:
        return 40.0;
      case Raridade.heroi:
        return 25.0;
      case Raridade.semideus:
        return 10.0;
      default:
        return 0.0;
    }
  }

  double get chanceEvolucao {
    final double nivelMedio =
        (criatura1.level + criatura2.level) / 2.0;
    final double chanceNivel = (nivelMedio / 10).clamp(0, 100);
    final double chanceRaridade =
        (chancePorRaridade(criatura1.raridade) +
         chancePorRaridade(criatura2.raridade)) / 2.0;
    return ((chanceNivel * 0.5) + (chanceRaridade * 0.5)).clamp(0, 100);
  }

  bool get ocorreEvolucao =>
      _random.nextDouble() * 100 <= chanceEvolucao;

  bool get cartasIguais =>
      criatura1.name == criatura2.name &&
      criatura1.raridade == criatura2.raridade;

  Creature fundir() {
    if (cartasIguais) {
      int novoNivel = criatura1.level + 1;
      Raridade novaRaridade = criatura1.raridade;

      if (ocorreEvolucao &&
          criatura1.raridade.index < Raridade.values.length - 2) {
        novaRaridade = Raridade.values[criatura1.raridade.index + 1];
      }

      return Creature(
        criatura1.vida,
        novoNivel,
        0.0, // XP resetada ou recalculada conforme lógica do jogo
        criatura1.elementos,
        novaRaridade,
        criatura1.ataques,
        criatura1.spriteFile,
        criatura1.name,
        criatura1.dimension,
      );
    } else {
      int nivelFinal =
          ((criatura1.level + criatura2.level) / 2).round();
      Raridade raridadeFinal = criatura1.raridade.index >
              criatura2.raridade.index
          ? criatura1.raridade
          : criatura2.raridade;

      if (ocorreEvolucao &&
          raridadeFinal.index < Raridade.values.length - 2) {
        raridadeFinal = Raridade.values[raridadeFinal.index + 1];
      }

      return Creature(
        (criatura1.vida + criatura2.vida) ~/ 2,
        nivelFinal,
        0.0,
        elementosFundidos..shuffle(),
        raridadeFinal,
        [...criatura1.ataques, ...criatura2.ataques],
        criatura1.spriteFile,
        "Criatura Fundida",
        criatura1.dimension,
      );
    }
  }
}