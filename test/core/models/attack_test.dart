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
  test("Teste de Ataque do Água contra o Fogo", ()
  {

    // De Água contra o Fogo
    double multiplicador1 =  ElementMap.multiplicadores[Elemento.agua]?[Elemento.fogo] ?? 1.0;
    double multiplicador2 =  ElementMap.multiplicadores[Elemento.agua]?[Elemento.fogo] ?? 1.0;
    double all_multiplicadores = (multiplicador1 + multiplicador2) / 2;
    int valor_esperado = (15 * all_multiplicadores).round(); // Base * Elemental, Cálculo do Elemental no GDD

    int dano = water_creature.ataques[0].calcDamage(fire_creature); // Cálculo de Dano na Criatura
    expect(valor_esperado, equals(dano)); // Verifica se o valor foi corretamente calculado
  });

  test("Teste de Ataque da Terra contro Fogo", ()
  {

    // De Água contra o Fogo
    double multiplicador1 =  ElementMap.multiplicadores[Elemento.terra]?[Elemento.fogo] ?? 1.0;
    double multiplicador2 =  ElementMap.multiplicadores[Elemento.terra]?[Elemento.fogo] ?? 1.0;
    double all_multiplicadores = (multiplicador1 + multiplicador2) / 2;
    int valor_esperado = (35 * all_multiplicadores).round(); // Base * Elemental, Cálculo do Elemental no GDD

    int dano = water_creature.ataques[1].calcDamage(fire_creature); // Cálculo de Dano na Criatura
    expect(valor_esperado, equals(dano)); // Verifica se o valor foi corretamente calculado
  });
  });
}