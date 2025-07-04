import 'package:game/core/models/attack_model.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:test/test.dart';

void main()
{
  group("Creature getCompletePath", (){
    test("Verificar se o Caminho Completo funciona", (){
      final Creature criatura = Creature(
        30,
        1,
        0,
        [Elemento.terra],
        Raridade.comum,
        [Attack("Nome Placeholder", 5, [Elemento.terra])],
        "/bintilin.png"
      );

      final String path = criatura.getCompletePath();
      expect("assets/sprites/bintilin.png", equals(path),
        reason: "O caminho não está correto",
      );
    });
  });
}