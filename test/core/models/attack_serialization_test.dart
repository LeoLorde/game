import '../../../lib/core/models/attack_model.dart';
import '../../../lib/core/models/creature_model.dart';
import '../../../lib/core/classes/element_map.dart';
import '../../../lib/core/enums/elemento_enum.dart';
import '../../../lib/core/enums/raridade_enum.dart';
import 'package:test/test.dart';

void main() {
  group('Attack toMap / fromMap', () {
    test('Verificar se o Attack está Serializando e Desserializando corretamente', () {

      // Cria um ataque original para o teste
      final originalAttack = Attack(
        'Chamas Eternas',
        42,
        [Elemento.fogo, Elemento.ar],
      );

      // Serializa com toMap
      final map = originalAttack.toMap();

      // Verifica se o mapa gerado tem os dados esperados no formato esperado
      expect(map['name'], equals('Chamas Eternas'), 
        reason: "Nome está Incorreto");
      expect(map['base_damage'], equals(42),
        reason: "Dano está Incorreto");
      expect(map['elementos'], equals([Elemento.fogo.index, Elemento.ar.index]),
        reason: "Index dos Enums dos Elementos estão Incorretos");

      // Desserializa com fromMap
      final attackRestaurado = Attack.fromMap(map);

      // Compara os dados restaurados com os originais
      expect(attackRestaurado.name, equals(originalAttack.name),
        reason: "Nome está diferente do original");
      expect(attackRestaurado.base_damage, equals(originalAttack.base_damage),
        reason: "Dano está diferente do original");
      expect(attackRestaurado.elementos, equals(originalAttack.elementos),
        reason: "Os elementos estão diferentes do original");
    });

    test("Verificar se um Ataque com 0 Elementos vai ser Serializado corretamente", (){
      Attack ataque = Attack("Ataque Merda", 5, []);
      final attack_map = ataque.toMap();
      final restaured = Attack.fromMap(attack_map);
      
      expect(ataque.elementos, equals(restaured.elementos),
        reason: "Ataque com 0 Elementos estão sendo Serializado Incorretamente"
        );
    });
  });
}