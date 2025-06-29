import '../enums/elemento_enum.dart';
import '../enums/raridade_enum.dart';
import './attack_model.dart';

class Creature {
  int vida;
  int ataque;
  List<Elemento> elementos;
  List<Attack> ataques;
  Raridade raridade;

  Creature(this.vida, this.ataque, this.elementos, this.raridade, this.ataques);
}
