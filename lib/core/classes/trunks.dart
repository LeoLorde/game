import 'dart:math';
import 'package:game/core/models/creature_model.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:game/core/enums/dimension_enum.dart';

void main() {
  int dimensao = 6;
  Random random = Random();

  List<String> tiposDeBaus = ['Midgard', 'Apolo', 'Hel', 'Odin', 'Zeus'];

  //Probabilidades padrão dos baús
  List<double> todasChances = [0.5, 0.2, 0.15, 0.1, 0.05];

  //Determina os baús permitidos conforme a dimensão
  List<String> bausPermitidos;
  List<double> chancesPermitidas;

  if (dimensao <= 3) {
    bausPermitidos = tiposDeBaus.sublist(0, 3);
    chancesPermitidas = todasChances.sublist(0, 3);
  } else if (dimensao <= 5) {
    bausPermitidos = tiposDeBaus.sublist(0, 4);
    chancesPermitidas = todasChances.sublist(0, 4);
  } else {
    bausPermitidos = tiposDeBaus;
    chancesPermitidas = todasChances;
  }

  //Realiza sorteio com base nas probabilidades
  String bauSorteado = sortearComChances(bausPermitidos, chancesPermitidas);
  print('Baú sorteado: $bauSorteado');

  //Sorteia raridade da criatura com fator multiplicador por dimensão
  sortearRaridade(bauSorteado, dimensao);

  //Gera recompensa em dinheiro e talismanes
  gerarRecompensa(bauSorteado);
}

String sortearComChances(List<String> opcoes, List<double> chances) {
  double r = Random().nextDouble();
  double acumulado = 0.0;

  for (int i = 0; i < opcoes.length; i++) {
    acumulado += chances[i];
    if (r <= acumulado) {
      return opcoes[i];
    }
  }
  return opcoes.last; //Caso extremo de arredondamento
}

void sortearRaridade(String bau, int dimensao) {
  Map<String, List<double>> baseChances = {
    'Midgard':   [80, 15, 3, 1.8, 0.2],
    'Apolo':     [50, 30, 17, 2.5, 0.5],
    'Hel':       [30, 35, 20, 12.5, 2.5],
    'Odin':      [15, 20, 30, 25, 10],
    'Zeus':      [5, 10, 25, 30, 30],
  };

  List<String> raridades = ['Combatente', 'Místico', 'Herói', 'Semideus', 'Deus'];

  //Aplica multiplicador por dimensão
  List<double> chances = baseChances[bau]!;
  double fator = pow(1.1, dimensao - 1).toDouble();
  List<double> ajustadas = chances.map((c) => c * fator).toList();

  //Normaliza para somar 1.0
  double total = ajustadas.reduce((a, b) => a + b);
  List<double> normalizadas = ajustadas.map((c) => c / total).toList();

  String raridadeSorteada = sortearComChances(raridades, normalizadas);
  print('Raridade sorteada: $raridadeSorteada');
}

void gerarRecompensa(String bau) {
  Map<String, List<int>> dinheiroPorBau = {
    'Midgard': [1000, 2000],
    'Apolo':   [2000, 4000],
    'Hel':     [4000, 6000],
    'Odin':    [6000, 8000],
    'Zeus':    [8000, 10000],
  };

  Map<String, List<int>> talismanesPorBau = {
    'Midgard': [1, 2],
    'Apolo':   [2, 4],
    'Hel':     [4, 6],
    'Odin':    [6, 8],
    'Zeus':    [8, 10],
  };

  Random r = Random();
  int dinheiro = dinheiroPorBau[bau]![0] + r.nextInt(dinheiroPorBau[bau]![1] - dinheiroPorBau[bau]![0] + 1);
  int talismanes = talismanesPorBau[bau]![0] + r.nextInt(talismanesPorBau[bau]![1] - talismanesPorBau[bau]![0] + 1);

  print('Recompensa: \$${dinheiro} e $talismanes talismanes');
}