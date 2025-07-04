import '../enums/elemento_enum.dart';
import '../enums/raridade_enum.dart';
import './attack_model.dart';

class Creature {
  int vida;
  int level;
  double xp;

  List<Elemento> elementos; // Permite Vários Elementos
  List<Attack> ataques; // Permite Vários Ataques
  Raridade raridade;

  String spriteFile; // Caminho do Sprite: /creature1.png
  final String filePath = "assets/sprites";
  String name;

  Creature(
    this.vida,
    this.level,
    this.xp,
    this.elementos,
    this.raridade,
    this.ataques,
    this.spriteFile,
    this.name,
  );

  // Retorna o CAMINHO COMPLETO do Sprite
  String getCompletePath() {
    return filePath + spriteFile;
  }

  // Transforma em um Dicionário (Facilita para uso em JSON)
  Map<String, dynamic> ToMap() {
    return {
      'vida': vida,
      'level': level,
      'xp': xp,
      'elementos':
          elementos.map((e) => e.index).toList(), // lista de ints direta
      'raridade': raridade.index,
      'ataques':
          ataques.map((a) => a.toMap()).toList(), // lista de mapas diretos
      'spriteFile': spriteFile,
      'name': name,
    };
  }

  factory Creature.fromMap(Map<String, dynamic> map) {
    return Creature(
      map['vida'] as int,
      map['level'] as int,
      (map['xp'] as num).toDouble(),
      (map['elementos'] as List<dynamic>)
          .map((i) => Elemento.values[i as int])
          .toList(),
      Raridade.values[map['raridade'] as int],
      (map['ataques'] as List<dynamic>)
          .map((a) => Attack.fromMap(a as Map<String, dynamic>))
          .toList(),
      map['spriteFile'] as String,
      map['name'] as String,
    );
  }
}
