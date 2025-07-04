import 'creature_model.dart';
import '../enums/elemento_enum.dart';
import '../classes/element_map.dart';
import 'dart:convert';
import 'attack_model.dart';

class Talismans{
  
}

class DamageTalismans extends Talismans {
  late int danoAprimorado;

  int DamageTalismansFunction(Attack ataque, Creature criatura) {
    int danoSemiFinal = ataque.calcDamage(criatura);
    danoAprimorado = danoSemiFinal * 2; 
    return danoAprimorado;
  }
}


class DefenseTalismans extends Talismans
{
  late int vidaAprimorada;

  DefenseTalismansFunction (Creature criatura) {
    vidaAprimorada = criatura.vida * 2;
    return vidaAprimorada;
  }
}