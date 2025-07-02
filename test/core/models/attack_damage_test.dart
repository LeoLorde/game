import '../../../lib/core/models/attack_model.dart';
import '../../../lib/core/models/creature_model.dart';
import '../../../lib/core/classes/element_map.dart';
import '../../../lib/core/enums/elemento_enum.dart';
import '../../../lib/core/enums/raridade_enum.dart';
import 'package:test/test.dart';

void main()
{
  group("Attack calcDamage", (){

    // Cria uma Criatura de Fogo
    Creature fire_creature = Creature(
      50,
      1,
      1,
      [Elemento.fogo, Elemento.fogo],
      Raridade.incomum,
      [
        Attack("Cuspe de Fogo", 15, [Elemento.fogo]),
        Attack("Ataque de Lava", 25, [Elemento.fogo])
      ],
      "Null"
    );

  // Cria uma Criatura de Água
  Creature water_creature = Creature(
      45,
      1,
      1,
      [Elemento.agua, Elemento.terra],
      Raridade.incomum,
      [
        Attack("Jato de Água", 15, [Elemento.agua]),
        Attack("Espinhos de Terra", 35, [Elemento.terra])  
      ],
      "Null"
    );
  
  // Fazendo o Teste de Cálculo de Dano
  test("Teste de Ataque da Água contra o Fogo", () {
    final atacante = Elemento.agua;
    final alvo = fire_creature;

    double multiplicadorMedio = alvo.elementos
        .map((elemento) => ElementMap.multiplicadores[atacante]?[elemento] ?? 1.0) // Cria uma Lista com o Multiplicador de CADA ELEMENTO
        .reduce((a, b) => a + b) / alvo.elementos.length; // Transforma essa lista em um único valor (uma soma), e em seguida divide pela quantidade deles

    int valorEsperado = (15 * multiplicadorMedio).round();
    int danoCalculado = water_creature.ataques[0].calcDamage(alvo);

    expect(danoCalculado, equals(valorEsperado),
        reason: "Dano da Água contra a Criatura de Fogo está incorreto");
});

test("Teste de Ataque da Terra contra o Fogo", () {
    final atacante = Elemento.terra;
    final alvo = fire_creature;

    double multiplicadorMedio = alvo.elementos
        .map((elemento) => ElementMap.multiplicadores[atacante]?[elemento] ?? 1.0) // Cria uma Lista com o Multiplicador de CADA ELEMENTO
        .reduce((a, b) => a + b) / alvo.elementos.length; // Transforma essa lista em um único valor (uma soma), e em seguida divide pela quantidade deles

    int valorEsperado = (35 * multiplicadorMedio).round();
    int danoCalculado = water_creature.ataques[1].calcDamage(alvo);

    expect(danoCalculado, equals(valorEsperado),
        reason: "Dano da Terra contra a Criatura de Fogo está incorreto");
});
});
  }