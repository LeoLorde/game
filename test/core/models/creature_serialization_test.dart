import 'package:game/core/models/attack_model.dart';

import 'package:game/core/models/creature_model.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:test/test.dart';

void main(){
    group('Creature toMap / fromMap', () {
    test('Verificar se o Creature está Serializando e Desserializando corretamente', () {

      Attack teste = Attack("Ataque Lixo", 5, [Elemento.agua]);
      // Cria um ataque original para o teste
      Creature nova_criatura = Creature(
        30,
        1,
        0,
        [Elemento.agua, Elemento.ar],
        Raridade.epica,
        [teste],
        "Null",
        "Criatura Teste"
      );

      // Serializa com toMap
      final map = nova_criatura.ToMap();

      // Verifica se o mapa gerado tem os dados esperados no formato esperado
      expect(map['vida'], equals(30), 
        reason: "A vida está Incorreta");
      expect(map['level'], equals(1),
        reason: "Level está Incorreto");
      expect(map['xp'], equals(0),
        reason: "XP está Incorreto");
      expect(map['raridade'], equals(Raridade.epica.index),
        reason: "Raridade está Incorreto");

      expect(map['ataques'][0]['name'], equals('Ataque Lixo'));
      expect(map['ataques'][0]['base_damage'], equals(5));
      expect(map['ataques'][0]['elementos'], equals([Elemento.agua.index]));

      expect(map['elementos'], equals([Elemento.agua.index, Elemento.ar.index]),
        reason: "Index dos Enums dos Elementos estão Incorretos");

      expect(map['name'], equals("Criatura Teste"));
      // Desserializa com fromMap
      final criatura_restaurada = Creature.fromMap(map);

      // Compara os dados restaurados com os originais
      expect(criatura_restaurada.vida, equals(nova_criatura.vida),
        reason: "Vida da Criatura está diferente do original");
      expect(criatura_restaurada.level, equals(nova_criatura.level),
        reason: "Dano está diferente do original");
      expect(criatura_restaurada.elementos, equals(nova_criatura.elementos),
        reason: "Os elementos estão diferentes do original");
      expect(criatura_restaurada.raridade, equals(nova_criatura.raridade),
        reason: "As raridades estão diferentes do original");
      expect(criatura_restaurada.ataques[0].toMap(), equals(nova_criatura.ataques[0].toMap()),
        reason: "Os ataques estão diferentes do original");
      expect(criatura_restaurada.name, equals(nova_criatura.name));
    });

    test("Verificar se o Creature com 0 Ataques será Serializado Corretamente", (){
      final Creature nova_criatura = Creature(
        30,
        1,
        0,
        [Elemento.agua, Elemento.ar],
        Raridade.epica,
        [], // Sem nenhum ataque
        "Null",
        "Criatura Teste"
      );

      final creature_map = nova_criatura.ToMap();
      final Creature restaured = Creature.fromMap(creature_map);

      expect(nova_criatura.ataques, equals(restaured.ataques), 
        reason: "Criatura com 0 Ataques está sendo Serializada com fromMap() incorretamente"
      );
    });
  });
}