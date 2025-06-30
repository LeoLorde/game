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

  Creature(this.vida, this.level, this.xp, this.elementos, this.raridade, this.ataques, this.spriteFile);

  // Retorna o CAMINHO COMPLETO do Sprite
  String getCompletePath() 
  {
    return filePath + spriteFile;
  }

  // Transforma em um Dicionário (Facilita para uso em JSON)
  Map<String, dynamic> ToMap() { 
  return {
    'vida': vida,
    'level': level,
    'xp': xp,
    'elementos': elementos.map((e) => e.index).toList(), // Salvar Enums como Índice
    'raridade': raridade.index,
    'ataques': ataques.map((a) => a.toMap()).toList(),  // Usa o toMap do Attack Model
    'spriteFile': spriteFile,
    };
  }

  // Cria um objeto Creature a partir de um Map (ex: vindo do banco ou JSON)
  factory Creature.fromMap(Map<String, dynamic> map) {
    return Creature(
      map['vida'],
      map['level'],
      map['xp'],
      (map['elementos'] as List).map((i) => Elemento.values[i]).toList(),
      Raridade.values[map['raridade']],
      (map['ataques'] as List).map((a) => Attack.fromMap(a)).toList(),
      map['spriteFile'],
    );
  }
}