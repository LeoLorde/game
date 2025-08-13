import 'package:game/core/enums/dimension_enum.dart';
import 'package:game/core/enums/elemento_enum.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/attack_model.dart';
import 'dart:convert';

class Creature {
  int? id; // ← campo adicionado
  int vida;
  int level;
  double xp;

  List<Elemento> elementos;
  List<Attack> ataques;
  Raridade raridade;

  String spriteFile; // Caminho do Sprite: /creature1.png
  final String filePath = "assets/sprites/";
  String name;

  DimensionEnum dimension;

  Creature(
    this.vida,
    this.level,
    this.xp,
    this.elementos,
    this.raridade,
    this.ataques,
    this.spriteFile,
    this.name,
    this.dimension, {
    this.id,
  });

  String getCompletePath() {
    return filePath + spriteFile + "_0.png";
  }

  String getDanagedCompletePath() {
    return filePath + spriteFile + "_1.png";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // ← incluído no mapa
      'vida': vida,
      'level': level,
      'xp': xp,
      'elementos': elementos.map((e) => e.index).toList(),
      'raridade': raridade.index,
      'ataques': ataques.map((a) => a.toMap()).toList(),
      'spriteFile': spriteFile,
      'name': name,
      'dimension': dimension.index,
    };
  }

  factory Creature.fromMap(Map<String, dynamic> map) {
    return Creature(
      map['vida'] as int,
      map['level'] as int,
      (map['xp'] as num).toDouble(),
      (jsonDecode(map['elementos'] as String) as List<dynamic>)
          .map((i) => Elemento.values[i as int])
          .toList(),
      Raridade.values[map['raridade'] as int],
      (jsonDecode(map['ataques'] as String) as List<dynamic>)
          .map((a) => Attack.fromMap(a as Map<String, dynamic>))
          .toList(),
      map['spriteFile'] as String,
      map['name'] as String,
      DimensionEnum.values[map['dimension'] as int],
      id: map['id'] as int?,
    );
  }
}
