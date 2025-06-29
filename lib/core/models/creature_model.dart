import '../enums/elemento_enum.dart';
import '../enums/raridade_enum.dart';

class Creature {
  int vida;
  int ataque;
  List<Elemento> elementos;
  Raridade raridade;

  Creature(this.vida, this.ataque, this.elementos, this.raridade);
}
