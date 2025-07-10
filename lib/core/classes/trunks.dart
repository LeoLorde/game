import 'dart:math';
import 'package:game/core/models/creature_model.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:game/core/enums/dimension_enum.dart';

// Lista de criaturas iniciais disponíveis para drop
final List<Creature> criaturasIniciais = [
  Creature(
    50,
    1,
    0,
    [Elemento.agua],
    Raridade.comum,
    [Attack("Jatada de Água", 5, [Elemento.agua])],
    "None",
    "Criatura Padrão de Água",
    DimensionEnum.terra,
  ),
  Creature(
    50,
    1,
    0,
    [Elemento.fogo],
    Raridade.comum,
    [Attack("Rabetada de Fogo", 5, [Elemento.fogo])],
    "None",
    "Criatura Padrão de Fogo",
    DimensionEnum.terra,
  ),
  Creature(
    50,
    1,
    0,
    [Elemento.terra],
    Raridade.comum,
    [Attack("Espinhos de Terra", 5, [Elemento.terra])],
    "None",
    "Criatura Padrão de Terra",
    DimensionEnum.terra,
  ),
  Creature(
    50,
    1,
    0,
    [Elemento.ar],
    Raridade.comum,
    [Attack("Corte de Vento", 5, [Elemento.ar])],
    "None",
    "Criatura Padrão de Ar",
    DimensionEnum.terra,
  ),
];

class Trunks {
  // Tabela que relaciona raridade com quantidade máxima de ouro
  final Map<int, int> tabelaOuroPorRaridade = {
    1: 10,
    2: 100,
    3: 1000,
  };

  // Método principal que simula um drop de ouro aleatório
  void gerarDropOuro() {
    final random = Random();

    // Sorteia uma raridade
    final chaveRaridade = tabelaOuroPorRaridade.keys.toList()[random.nextInt(tabelaOuroPorRaridade.length)];

    // Obtém o valor máximo de ouro associado à raridade
    final valorMaximo = tabelaOuroPorRaridade[chaveRaridade]!;

    // Gera quantidade aleatória de ouro entre metade e o valor máximo
    final ouro = gerarValorAleatorio(valorMaximo);

    print('Ouro gerado com raridade $chaveRaridade: $ouro');
  }

  // Função que retorna valor entre 50% e 100% do valor máximo
  int gerarValorAleatorio(int valorMaximo) {
    final random = Random();
    final minimo = (valorMaximo / 2).round();
    return minimo + random.nextInt(valorMaximo - minimo + 1);
  }

  // Sorteia uma criatura aleatória da lista de criaturas disponíveis
  Creature sortearCriatura() {
    final random = Random();
    return criaturasIniciais[random.nextInt(criaturasIniciais.length)];
  }
}